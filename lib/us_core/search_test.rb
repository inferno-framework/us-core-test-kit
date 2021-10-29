module USCore
  module SearchTest
    def perform_search_test(resources, reply_handler = nil)
      fhir_search resource_type, search_params

      # TODO: handle searches w/status

      assert_response_ok

      # TODO:
      # assert_valid_bundle_entries(resource_types: [resource, 'OperationOutcome'])

      resources_returned =
        fetch_all_bundled_resources.select { |resource| resource.resourceType == resource_type }

      scratch[:allergy_intolerance_resources] = resources_returned
      scratch[:resources_returned] = resources_returned
      scratch[:search_parameters_used] = resources_returned

      # TODO: save_delayed_references

      skip_if resources_returned.empty?, no_resources_skip_message
    end

    def no_resources_skip_message
      "No #{resource_type} resources appear to be available. " \
      "Please use patients with more information"
    end

    def fetch_all_bundled_resources(reply_handler: nil, max_pages: 20)
      page_count = 1
      resources = []

      until bundle.nil? || page_count == max_pages
        resources += bundle&.entry&.map { |entry| entry&.resource }
        next_bundle_link = bundle&.link&.find { |link| link.relation == 'next' }&.url
        reply_handler&.call(response)

        break if next_bundle_link.blank?

        reply = client.raw_read_url(next_bundle_link)
        # TODO:
        # store_request('outgoing') { reply }
        error_message = cant_resolve_next_bundle_message(next_bundle_link)

        assert_response_ok(error_message: error_message)
        assert_valid_json(reply.body, error_message)

        bundle = client.parse_reply(FHIR::Bundle, client.default_format, reply)

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

    def search_param_value(element, include_system = false)
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
            coding_with_code = find_value_at(element, 'coding') { |coding| coding.code.present? }
            coding_with_code.present? ? "#{coding_with_code.system}|#{coding_with_code.code}" : nil
          else
            find_value_at(element, 'coding.code')
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
  end
end
