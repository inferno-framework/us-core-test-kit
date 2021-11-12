require_relative 'search_test_properties'

module USCore
  module SearchTest
    extend Forwardable

    def_delegators 'self.class', :metadata
    def_delegators 'properties',
                   :resource_type,
                   :search_param_names,
                   :saves_delayed_references?,
                   :first_search?,
                   :fixed_value_search?
    # def self.included(klass)
    #   klass.extend(ClassMethods)
    # end

    # module ClassMethods
    # end

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
          new_params.reject! { |params| params.any?(&:blank?) }

          params[patient_id].concat(new_params)
        end
    end

    def any_valid_search_params?
      all_search_params.any? { |_patient_id, params| params.present? }
    end

    def run_search_test
      skip_if !any_valid_search_params?, unable_to_resolve_params_message

      resources_returned =
        all_search_params.flat_map do |patient_id, params_list|
          params_list.flat_map { |params| perform_search(params, patient_id) }
        end

      skip_if resources_returned.empty?, no_resources_skip_message
    end

    def perform_search(params, patient_id)
      # TODO: skip if not supported?

      fhir_search resource_type, params: params

      # TODO: handle medication inclusion
      # TODO: handle searches w/status
      # TODO: handle search comparators

      assert_response_status(200)

      # NOTE: do we even want to do any validation here?
      # assert_valid_bundle_entries(resource_types: [resource_type, 'OperationOutcome'])

      resources_returned =
        fetch_all_bundled_resources.select { |resource| resource.resourceType == resource_type }

      # TODO: validate that responses match query

      all_scratch_resources.concat(resources_returned).uniq!
      scratch_resources_for_patient(patient_id).concat(resources_returned).uniq!
      # scratch[:resources_returned] = resources_returned
      # scratch[:search_parameters_used] = resources_returned

      # TODO: handle search variants: references, codes, POST

      save_delayed_references(resources_returned) if saves_delayed_references?

      resources_returned
    end

    def all_scratch_resources
      scratch_resources[:all] ||= []
    end

    def scratch_resources_for_patient(patient_id)
      return all_scratch_resources if patient_id.nil?

      scratch_resources[patient_id] ||= []
    end

    def references_to_save
      @references_to_save ||= metadata.delayed_references.freeze
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
        value = patient_id_param?(name) ? patient_id : search_param_value(search_param_path(name), patient_id)
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

    def search_param_path(name)
      path = metadata.search_definitions[name.to_sym][:path]
      path == 'class' ? 'local_class' : path
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

    def no_resources_skip_message
      "No #{resource_type} resources appear to be available. " \
      "Please use patients with more information"
    end

    def fetch_all_bundled_resources(reply_handler: nil, max_pages: 20)
      page_count = 1
      resources = []
      bundle = resource

      until bundle.nil? || page_count == max_pages
        resources += bundle&.entry&.map { |entry| entry&.resource }
        next_bundle_link = bundle&.link&.find { |link| link.relation == 'next' }&.url
        reply_handler&.call(response)

        break if next_bundle_link.blank?

        reply = fhir_client.raw_read_url(next_bundle_link)
        # TODO:
        # store_request('outgoing') { reply }
        error_message = cant_resolve_next_bundle_message(next_bundle_link)

        assert_response_status(200)
        assert_valid_json(reply.body, error_message)

        bundle = fhir_client.parse_reply(FHIR::Bundle, fhir_client.default_format, reply)

        page_count += 1
      end

      resources
    end

    def cant_resolve_next_bundle_message(link)
      "Could not resolve next bundle: #{link}"
    end

    def find_a_value_at(element, path)
      return nil if element.nil?

      elements = Array.wrap(element)

      if path.empty?
        return elements.find { |el| yield(el) } if block_given?

        return elements.first
      end

      path_segments = path.split('.')
      segment = path_segments.shift.to_sym

      no_elements_present =
        elements.none? do |element|
          child = element.send(segment)

          child.present? || child == false
        end

      return nil if no_elements_present

      elements.each do |element|
        child = element.send(segment)
        element_found =
          if block_given?
            find_a_value_at(child, path_segments.join('.')) { |value_found| yield(value_found) }
          else
            find_a_value_at(child, path_segments.join('.'))
          end

        return element_found if element_found.present? || element_found == false
      end

      nil
    end

    def search_param_value(path, patient_id, include_system = false)
      element = find_a_value_at(scratch_resources_for_patient(patient_id), path)
      search_value =
        case element
        when FHIR::Period
          if element.start.present?
            'gt' + (DateTime.xmlschema(element.start) - 1).xmlschema
          else
            # TODO
            # end_datetime = get_fhir_datetime_range(element.end)[:end]
            # 'lt' + (end_datetime + 1).xmlschema
          end
        when FHIR::Reference
          element.reference
        when FHIR::CodeableConcept
          if include_system
            # TODO: fix if system is blank
            coding_with_code = find_a_value_at(element, 'coding') { |coding| coding.code.present? }
            coding_with_code.present? ? "#{coding_with_code.system}|#{coding_with_code.code}" : nil
          else
            find_a_value_at(element, 'coding.code')
          end
        when FHIR::Identifier
          if include_system
            # TODO: fix if system is blank
            "#{element.system}|#{element.value}"
          else
            element.value
          end
        when FHIR::Coding
          if include_system
            # TODO: fix if system is blank
            "#{element.system}|#{element.code}"
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
      escaped_value = search_value&.gsub(',', '\\,')
      escaped_value
    end

    def save_resource_reference(resource_type, reference)
      scratch[:references] ||= {}
      scratch[:references][resource_type] ||= Set.new
      scratch[:references][resource_type] << reference
    end

    def save_delayed_references(resources)
      resources.each do |resource|
        references_to_save.each do |reference_to_save|
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

    def resolve_path(elements, path)
      elements = Array.wrap(elements)
      return elements if path.blank?

      paths = path.split('.')

      elements.flat_map do |element|
        resolve_path(element&.send(paths.first), paths.drop(1).join('.'))
      end.compact
    end
  end
end
