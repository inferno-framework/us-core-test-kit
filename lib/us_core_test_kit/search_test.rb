require_relative 'date_search_validation'
require_relative 'fhir_resource_navigation'
require_relative 'search_test_properties'

module USCoreTestKit
  module SearchTest
    extend Forwardable
    include DateSearchValidation
    include FHIRResourceNavigation

    def_delegators 'self.class', :metadata, :provenance_metadata, :properties
    def_delegators 'properties',
                   :resource_type,
                   :search_param_names,
                   :saves_delayed_references?,
                   :first_search?,
                   :fixed_value_search?,
                   :possible_status_search?,
                   :test_medication_inclusion?,
                   :test_post_search?,
                   :token_search_params,
                   :test_reference_variants?,
                   :params_with_comparators,
                   :multiple_or_search_params

    def all_search_params
      @all_search_params ||=
        patient_id_list.each_with_object({}) do |patient_id, params|
          params[patient_id] ||= []
          new_params =
            if fixed_value_search?
              fixed_value_search_param_values.map { |value| fixed_value_search_params(value, patient_id) }
            else
              [search_params_with_values(patient_id)]
            end
          new_params.reject! do |params|
            params.any? { |_key, value| value.blank? }
          end

          params[patient_id].concat(new_params)
        end
    end

    def all_provenance_revinclude_search_params
      @all_provenance_revinclude_search_params ||=
        all_search_params.transform_values! do |params_list|
          params_list.map { |params| params.merge(_revinclude: 'Provenance:target') }
        end
    end

    def any_valid_search_params?(search_params)
      search_params.any? { |_patient_id, params| params.present? }
    end

    def run_provenance_revinclude_search_test
      # TODO: skip if not supported?
      skip_if !any_valid_search_params?(all_provenance_revinclude_search_params), unable_to_resolve_params_message

      provenance_resources =
        all_provenance_revinclude_search_params.flat_map do |_patient_id, params_list|
          params_list.flat_map do |params|
            fhir_search resource_type, params: params

            perform_search_with_status(params, patient_id) if response[:status] == 400 && possible_status_search?

            check_search_response

            fetch_all_bundled_resources(additional_resource_types: ['Provenance'])
              .select { |resource| resource.resourceType == 'Provenance' }
          end
        end

      scratch_provenance_resources[:all] ||= []
      scratch_provenance_resources[:all].concat(provenance_resources)

      save_delayed_references(provenance_resources, 'Provenance')

      skip_if provenance_resources.empty?, no_resources_skip_message('Provenance')
    end

    def run_search_test
      # TODO: skip if not supported?
      skip_if !any_valid_search_params?(all_search_params), unable_to_resolve_params_message

      resources_returned =
        all_search_params.flat_map do |patient_id, params_list|
          params_list.flat_map { |params| perform_search(params, patient_id) }
        end

      skip_if resources_returned.empty?, no_resources_skip_message

      perform_multiple_or_search_test if multiple_or_search_params.present?
    end

    def perform_search(params, patient_id)
      fhir_search resource_type, params: params

      perform_search_with_status(params, patient_id) if response[:status] == 400 && possible_status_search?

      check_search_response

      resources_returned =
        fetch_all_bundled_resources.select { |resource| resource.resourceType == resource_type }

      return [] if resources_returned.blank?

      perform_comparator_searches(params, patient_id) if params_with_comparators.present?

      filter_devices(resources_returned) if resource_type == 'Device'

      if first_search?
        all_scratch_resources.concat(resources_returned).uniq!
        scratch_resources_for_patient(patient_id).concat(resources_returned).uniq!
      end

      resources_returned.each do |resource|
        check_resource_against_params(resource, params)
      end

      save_delayed_references(resources_returned) if saves_delayed_references?

      return resources_returned if all_search_variants_tested?

      perform_post_search(resources_returned, params) if test_post_search?
      test_medication_inclusion(resources_returned, params, patient_id) if test_medication_inclusion?
      perform_reference_with_type_search(params, resources_returned.count) if test_reference_variants?
      perform_search_with_system(params, patient_id) if token_search_params.present?

      resources_returned
    end

    def perform_post_search(get_search_resources, params)
      fhir_search resource_type, params: params, search_method: :post

      check_search_response

      post_search_resources = fetch_all_bundled_resources.select { |resource| resource.resourceType == resource_type }
      get_resource_count = get_search_resources.length
      post_resource_count = post_search_resources.length

      search_variant_test_records[:post_variant] = true

      assert get_resource_count == post_resource_count,
             "Expected search by POST to return the same results as search by GET, " \
             "but GET search returned #{get_resource_count} resources, and POST search " \
             "returned #{post_resource_count} resources."
    end

    def filter_devices(resources)
      codes_to_include = implantable_device_codes&.split(',')&.map(&:strip)
      return resources if codes_to_include.blank?

      resources.select! do |resource|
        resource&.type&.coding&.any? { |coding| codes_to_include.include?(coding.code) }
      end
    end

    def search_and_check_response(params, resource_type = self.resource_type)
      fhir_search resource_type, params: params

      check_search_response
    end

    def check_search_response
      assert_response_status(200)
      assert_resource_type(:bundle)
      # NOTE: how do we want to handle validating Bundles?
    end

    def search_variant_test_records
      @search_variant_test_records ||= initial_search_variant_test_records
    end

    def initial_search_variant_test_records
      {}.tap do |records|
        records[:post_variant] = false if test_post_search?
        records[:medication_inclusion] = false if test_medication_inclusion?
        records[:reference_variants] = false if test_reference_variants?
        records[:token_variants] = false if token_search_params.present?
        records[:comparator_searches] = Set.new if params_with_comparators.present?
      end
    end

    def all_search_variants_tested?
      search_variant_test_records.all? { |_variant, tested| tested.present? } &&
        all_comparator_searches_tested?
    end

    def all_comparator_searches_tested?
      return true if params_with_comparators.blank?

      Set.new(params_with_comparators) == search_variant_test_records[:comparator_searches]
    end

    def date_comparator_value(comparator, date)
      date = date.start || date.end if date.is_a? FHIR::Period
      case comparator
      when 'lt', 'le'
        comparator + (DateTime.xmlschema(date) + 1).xmlschema
      when 'gt', 'ge'
        comparator + (DateTime.xmlschema(date) - 1).xmlschema
      else
        # ''
        raise "Unsupported comparator '#{comparator}'"
      end
    end

    def required_comparators(name)
      metadata
        .search_definitions
        .dig(name.to_sym, :comparators)
        .select { |_comparator, expectation| expectation == 'SHALL' }
        .keys
        .map(&:to_s)
    end

    def perform_comparator_searches(params, patient_id)
      params_with_comparators.each do |name|
        next if search_variant_test_records[:comparator_searches].include? name

        required_comparators(name).each do |comparator|
          paths = search_param_paths(name).first
          date_element = find_a_value_at(scratch_resources_for_patient(patient_id), paths)
          params_with_comparator = params.merge(name => date_comparator_value(comparator, date_element))

          search_and_check_response(params_with_comparator)

          fetch_all_bundled_resources
            .each { |resource| check_resource_against_params(resource, params_with_comparator) }
        end

        search_variant_test_records[:comparator_searches] << name
      end
    end

    def perform_reference_with_type_search(params, resource_count)
      return if resource_count == 0
      return if search_variant_test_records[:reference_variants]

      new_search_params = params.merge('patient' => "Patient/#{params['patient']}")
      search_and_check_response(new_search_params)

      new_resource_count =
        fetch_all_bundled_resources
          .select { |resource| resource.resourceType == resource_type }
          .count

      assert new_resource_count == resource_count,
             "Expected search by `#{params['patient']}` to to return the same results as searching " \
             "by `#{new_search_params['patient']}`, but found #{resource_count} resources with " \
             "`#{params['patient']}` and #{new_resource_count} with `#{new_search_params['patient']}`"

      search_variant_test_records[:reference_variants] = true
    end

    def perform_search_with_system(params, patient_id)
      return if search_variant_test_records[:token_variants]

      new_search_params = token_search_params.each_with_object({}) do |name, search_params|
        search_params[name] = search_param_value(name, patient_id, include_system: true)
      end
      return if new_search_params.any? { |_name, value| value.blank? }

      search_params = params.merge(new_search_params)
      search_and_check_response(search_params)

      resources_returned =
        fetch_all_bundled_resources
          .select { |resource| resource.resourceType == resource_type }

      assert resources_returned.present?, "No resources were returned when searching by `system|code`"

      search_variant_test_records[:token_variants] = true
    end

    def perform_search_with_status(
          original_params,
          patient_id,
          status_search_values: self.status_search_values,
          resource_type: self.resource_type
        )
      assert resource.is_a?(FHIR::OperationOutcome), "Server returned a status of 400 without an OperationOutcome"
      # TODO: warn about documenting status requirements
      status_search_values.flat_map do |status_value|
        search_params = original_params.merge("#{status_search_param_name}": status_value)

        search_and_check_response(search_params)

        entries = resource.entry.select { |entry| entry.resource.resourceType == resource_type }

        if entries.present?
          original_params.merge!("#{status_search_param_name}": status_value)
          break
        end
      end
    end

    def status_search_param_name
      @status_search_param_name ||=
        metadata.search_definitions.keys.find { |key| key.to_s.include? 'status' }
    end

    def status_search_values
      default_search_values(status_search_param_name)
    end

    def default_search_values(param_name)
      definition = metadata.search_definitions[param_name]
      return [] if definition.blank?

      definition[:multiple_or] == 'SHALL' ? [definition[:values].join(',')] : Array.wrap(definition[:values])
    end


    def perform_multiple_or_search_test
      resolved_one = false

      all_search_params.each do |patient_id, params_list|
        next unless params_list.present?

        search_params = params_list.first
        existing_values = {}
        missing_values = {}

        multiple_or_search_params.each do |param_name|
          search_value = default_search_values(param_name.to_sym)
          search_params = search_params.merge("#{param_name}" => search_value)
          existing_values[param_name.to_sym] = scratch_resources_for_patient(patient_id).map(&param_name.to_sym).compact.uniq
        end

        # skip patient without multiple-or values
        next if existing_values.values.any?(&:empty?)

        resolved_one = true

        search_and_check_response(search_params)

        resources_returned =
          fetch_all_bundled_resources
            .select { |resource| resource.resourceType == resource_type }

        multiple_or_search_params.each do |param_name|
          missing_values[param_name.to_sym] = existing_values[param_name.to_sym] - resources_returned.map(&param_name.to_sym)
        end

        missing_value_message = missing_values
          .reject { |_param_name, missing_value| missing_value.empty? }
          .map { |param_name, missing_value| "#{missing_value.join(',')} values from #{param_name}" }
          .join(' and ')

        assert missing_value_message.blank?, "Could not find #{missing_value_message} in any of the resources returned for Patient/#{patient_id}"

        break if resolved_one
      end
    end

    def test_medication_inclusion(medication_requests, params, patient_id)
      return if search_variant_test_records[:medication_inclusion]

      scratch[:medication_resources] ||= {}
      scratch[:medication_resources][:all] ||= []
      scratch[:medication_resources][patient_id] ||= []
      scratch[:medication_resources][:contained] ||= []

      requests_with_external_references =
        medication_requests
          .select { |request| request&.medicationReference&.present? }
          .reject { |request| request&.medicationReference&.reference&.start_with? '#' }

      contained_medications =
        medication_requests
          .select { |request| request&.medicationReference&.reference&.start_with? '#' }
          .flat_map(&:contained)
          .select { |resource| resource.resourceType == 'Medication' }

      scratch[:medication_resources][:all] += contained_medications
      scratch[:medication_resources][patient_id] += contained_medications
      scratch[:medication_resources][:contained] += contained_medications

      return if requests_with_external_references.blank?

      search_params = params.merge(_include: 'MedicationRequest:medication')

      search_and_check_response(search_params)

      medications = fetch_all_bundled_resources.select { |resource| resource.resourceType == 'Medication' }
      assert medications.present?, 'No Medications were included in the search results'

      medications.uniq!(&:id)

      scratch[:medication_resources][:all] += medications
      scratch[:medication_resources][patient_id] += medications

      search_variant_test_records[:medication_inclusion] = true
    end

    def all_scratch_resources
      scratch_resources[:all] ||= []
    end

    def scratch_resources_for_patient(patient_id)
      return all_scratch_resources if patient_id.nil?

      scratch_resources[patient_id] ||= []
    end

    def references_to_save(resource_type = nil)
      reference_metadata = resource_type == 'Provenance' ? provenance_metadata : metadata
      reference_metadata.delayed_references
    end

    def fixed_value_search_param_name
      (search_param_names - ['patient']).first
    end

    def fixed_value_search_param_values
      metadata.search_definitions[fixed_value_search_param_name.to_sym][:values]
    end

    def fixed_value_search_params(value, patient_id)
      search_param_names.each_with_object({}) do |name, params|
        patient_id_param?(name) ? params[name] = patient_id : params[name] = value
      end
    end

    def search_params_with_values(patient_id)
      search_param_names.each_with_object({}) do |name, params|
        value = patient_id_param?(name) ? patient_id : search_param_value(name, patient_id)
        params[name] = value
      end
    end

    def patient_id_list
      return [nil] unless respond_to? :patient_ids

      patient_ids.split(',').map(&:strip)
    end

    def patient_search?
      search_param_names.any? { |name| patient_id_param? name }
    end

    def patient_id_param?(name)
      name == 'patient' || (name == '_id' && resource_type == 'Patient')
    end

    def search_param_paths(name)
      paths = metadata.search_definitions[name.to_sym][:paths]
      if paths.first =='class'
        paths[0] = 'local_class'
      end

      paths
    end

    def all_search_params_present?(params)
      params.all? { |_name, value| value.present? }
    end

    def array_of_codes(array)
      array.map { |name| "`#{name}`" }.join(', ')
    end

    def unable_to_resolve_params_message
      "Could not find values for all search params #{array_of_codes(search_param_names)}"
    end

    def empty_search_params_message(empty_search_params)
      "Could not find values for the search parameters #{array_of_codes(empty_search_params.keys)}"
    end

    def no_resources_skip_message(resource_type = self.resource_type)
      "No #{resource_type} resources appear to be available. " \
      "Please use patients with more information"
    end

    def fetch_all_bundled_resources(
          reply_handler: nil,
          max_pages: 20,
          additional_resource_types: [],
          resource_type: self.resource_type
        )
      page_count = 1
      resources = []
      bundle = resource

      until bundle.nil? || page_count == max_pages
        resources += bundle&.entry&.map { |entry| entry&.resource }
        next_bundle_link = bundle&.link&.find { |link| link.relation == 'next' }&.url
        reply_handler&.call(response)

        break if next_bundle_link.blank?

        reply = fhir_client.raw_read_url(next_bundle_link)

        store_request('outgoing') { reply }
        error_message = cant_resolve_next_bundle_message(next_bundle_link)

        assert_response_status(200)
        assert_valid_json(reply.body, error_message)

        bundle = fhir_client.parse_reply(FHIR::Bundle, fhir_client.default_format, reply)

        page_count += 1
      end

      valid_resource_types = [resource_type, 'OperationOutcome'].concat(additional_resource_types)
      valid_resource_types << 'Medication' if resource_type == 'MedicationRequest'

      all_valid_resource_types =
        resources.all? { |entry| valid_resource_types.include? entry.resourceType }

      assert all_valid_resource_types,
             "All resources returned must be of the type: #{valid_resource_types.join(', ')}"

      resources
    end

    def cant_resolve_next_bundle_message(link)
      "Could not resolve next bundle: #{link}"
    end

    def search_param_value(name, patient_id, include_system: false)
      paths = search_param_paths(name)
      search_value = nil
      paths.each do |path|
        element = find_a_value_at(scratch_resources_for_patient(patient_id), path)

        search_value =
          case element
          when FHIR::Period
            if element.start.present?
              'gt' + (DateTime.xmlschema(element.start) - 1).xmlschema
            else
              end_datetime = get_fhir_datetime_range(element.end)[:end]
              'lt' + (end_datetime + 1).xmlschema
            end
          when FHIR::Reference
            element.reference
          when FHIR::CodeableConcept
            if include_system
              coding =
                find_a_value_at(element, 'coding') { |coding| coding.code.present? && coding.system.present? }
              coding.present? ? "#{coding.system}|#{coding.code}" : nil
            else
              find_a_value_at(element, 'coding.code')
            end
          when FHIR::Identifier
            if include_system
              identifier = find_a_value_at(scratch_resources_for_patient(patient_id), path) do |identifier|
                identifier.value.present? && identifier.system.present?
              end
              identifier.present? ? "#{identifier.system}|#{identifier.value}" : nil
            else
              element.value
            end
          when FHIR::Coding
            if include_system
              coding = find_a_value_at(scratch_resources_for_patient(patient_id), path) do |coding|
                coding.code.present? && coding.system.present?
              end
              coding.present? ? "#{coding.system}|#{coding.code}" : nil
            else
              element.code
            end
          when FHIR::HumanName
            element.family || element.given&.first || element.text
          when FHIR::Address
            element.text || element.city || element.state || element.postalCode || element.country
          else
            element
          end

          break if search_value.present?
      end

      escaped_value = search_value&.gsub(',', '\\,')
      escaped_value
    end

    def save_resource_reference(resource_type, reference)
      scratch[:references] ||= {}
      scratch[:references][resource_type] ||= Set.new
      scratch[:references][resource_type] << reference
    end

    def save_delayed_references(resources, containing_resource_type = self.resource_type)
      resources.each do |resource|
        references_to_save(containing_resource_type).each do |reference_to_save|
          resolve_path(resource, reference_to_save[:path])
            .select { |reference| reference.is_a?(FHIR::Reference) && !reference.contained? }
            .each do |reference|
              resource_type = reference.resource_class.name.demodulize
              need_to_save = reference_to_save[:resources].include?(resource_type)
              next unless need_to_save

              save_resource_reference(resource_type, reference)
            end
        end
      end
    end

    #### RESULT CHECKING ####

    def check_resource_against_params(resource, params)
      params.each do |name, search_value|
        paths = search_param_paths(name)

        match_found = false
        values_found = []

        paths.each do |path|
          type = metadata.search_definitions[name.to_sym][:type]
          values_found =
            resolve_path(resource, path)
              .map do |value|
                if value.is_a? FHIR::Reference
                  value.reference
                else
                  value
                end
              end

          match_found =
            case type
            when 'Period', 'date', 'instant', 'dateTime'
              values_found.any? { |date| validate_date_search(search_value, date) }
            when 'HumanName'
              # When a string search parameter refers to the types HumanName and Address,
              # the search covers the elements of type string, and does not cover elements such as use and period
              # https://www.hl7.org/fhir/search.html#string
              search_value_downcase = search_value.downcase
              values_found.any? do |name|
                name&.text&.downcase&.start_with?(search_value_downcase) ||
                  name&.family&.downcase&.start_with?(search_value_downcase) ||
                  name&.given&.any? { |given| given.downcase.start_with?(search_value_downcase) } ||
                  name&.prefix&.any? { |prefix| prefix.downcase.start_with?(search_value_downcase) } ||
                  name&.suffix&.any? { |suffix| suffix.downcase.start_with?(search_value_downcase) }
              end
            when 'Address'
              search_value_downcase = search_value.downcase
              values_found.any? do |address|
                address&.text&.downcase&.start_with?(search_value_downcase) ||
                address&.city&.downcase&.start_with?(search_value_downcase) ||
                address&.state&.downcase&.start_with?(search_value_downcase) ||
                address&.postalCode&.downcase&.start_with?(search_value_downcase) ||
                address&.country&.downcase&.start_with?(search_value_downcase)
              end
            when 'CodeableConcept'
              # FHIR token search (https://www.hl7.org/fhir/search.html#token): "When in doubt, servers SHOULD
              # treat tokens in a case-insensitive manner, on the grounds that including undesired data has
              # less safety implications than excluding desired behavior".
              codings = values_found.flat_map(&:coding)
              if search_value.include? '|'
                system = search_value.split('|').first
                code = search_value.split('|').last
                codings&.any? { |coding| coding.system == system && coding.code&.casecmp?(code) }
              else
                codings&.any? { |coding| coding.code&.casecmp?(search_value) }
              end
            when 'Coding'
              if search_value.include? '|'
                system = search_value.split('|').first
                code = search_value.split('|').last
                values_found.any? { |coding| coding.system == system && coding.code&.casecmp?(code) }
              else
                values_found.any? { |coding| coding.code&.casecmp?(search_value) }
              end
            when 'Identifier'
              if search_value.include? '|'
                values_found.any? { |identifier| "#{identifier.system}|#{identifier.value}" == search_value }
              else
                values_found.any? { |identifier| identifier.value == search_value }
              end
            when 'string'
              searched_values = search_value.downcase.split(/(?<!\\\\),/).map{ |string| string.gsub('\\,', ',') }
              values_found.any? do |value_found|
                searched_values.any? { |searched_value| value_found.downcase.starts_with? searched_value }
              end
            else
              # searching by patient requires special case because we are searching by a resource identifier
              # references can also be URLs, so we may need to resolve those URLs
              if ['subject', 'patient'].include? name.to_s
                id = search_value.split('Patient/').last
                possible_values = [id, "Patient/#{id}", "#{url}/Patient/#{id}"]
                values_found.any? do |reference|
                  possible_values.include? reference
                end
              else
                search_values = search_value.split(/(?<!\\\\),/).map { |string| string.gsub('\\,', ',') }
                values_found.any? { |value_found| search_values.include? value_found }
              end
            end

          break if match_found
        end

        assert match_found,
               "#{resource_type}/#{resource.id} did not match the search parameters:\n" \
               "* Expected: #{search_value}\n" \
               "* Found: #{values_found.map(&:inspect).join(', ')}"
      end
    end
  end
end
