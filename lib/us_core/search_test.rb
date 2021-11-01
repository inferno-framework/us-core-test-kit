module USCore
  module SearchTest
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def references_to_save
        @references_to_save ||= metadata.delayed_references.freeze
      end

      def first_search?
        @first_search ||= id.end_with?(first_search_id)
      end

      def first_search_id
        metadata.tests
          .select { |test| test[:id].include? 'search' }
          .first[:id]
      end

      def need_to_save_references?
        first_search? && references_to_save.present?
      end
    end

    def perform_search_test(reply_handler = nil)
      check_search_params

      fhir_search resource_type, params: search_params

      # TODO: handle searches w/status

      assert_response_status(200)

      # TODO:
      # assert_valid_bundle_entries(resource_types: [resource, 'OperationOutcome'])

      resources_returned =
        fetch_all_bundled_resources.select { |resource| resource.resourceType == resource_type }

      scratch_resources.concat(resources_returned).uniq!
      # scratch[:resources_returned] = resources_returned
      # scratch[:search_parameters_used] = resources_returned

      save_delayed_references(resources_returned) if self.class.need_to_save_references?

      skip_if resources_returned.empty?, no_resources_skip_message
    end

    def check_search_params
      empty_search_params = search_params.select { |_name, value| value.blank? }

      skip_if empty_search_params.present?, empty_search_params_message(empty_search_params)
    end

    def empty_search_params_message(empty_search_params)
      list = empty_search_params.keys.map { |name| "`#{name}`" }.join(', ')

      "Could not find values for the search parameters #{list}"
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

    def search_param_value(path, include_system = false)
      element = find_a_value_at(scratch_resources, path)
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
        self.class.references_to_save.each do |reference_to_save|
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
