require_relative 'fhir_resource_navigation'

module USCoreTestKit
  module MustSupportTest
    extend Forwardable
    include FHIRResourceNavigation

    def_delegators 'self.class', :metadata

    def all_scratch_resources
      scratch_resources[:all]
    end

    def perform_must_support_test(resources)
      skip_if resources.blank?, "No #{resource_type} resources were found"

      if (missing_elements(resources) + missing_slices(resources)).length.zero?
        pass
      end

      skip "Could not find #{missing_must_support_strings.join(', ')} in the #{resources.length} " \
           "provided #{resource_type} resource(s)"
    end

    def missing_must_support_strings
      missing_elements.map { |element_definition| missing_element_string(element_definition) } +
        missing_slices.map { |slice_definition| slice_definition[:name] } +
        missing_extensions.map { |extension_definition| extension_definition[:id] }
    end

    def missing_element_string(element_definition)
      if element_definition[:fixed_value].present?
        "#{element_definition[:path]}:#{element_definition[:fixed_value]}"
      else
        element_definition[:path]
      end
    end

    def must_support_extensions
      metadata.must_supports[:extensions]
    end

    def missing_extensions(resources = [])
      @missing_extensions ||=
        must_support_extensions.select do |extension_definition|
          resources.none? do |resource|
            resource.extension.any? { |extension| extension.url == extension_definition[:url] }
          end
        end
    end

    def must_support_elements
      metadata.must_supports[:elements]
    end

    def missing_elements(resources = [])
      @missing_elements ||=
        must_support_elements.select do |element_definition|
          resources.none? do |resource|
            path = element_definition[:path] #.delete_suffix('[x]')
            value_found = find_a_value_at(resource, path) do |value|
              value_without_extensions =
                value.respond_to?(:to_hash) ? value.to_hash.reject { |key, _| key == 'extension' } : value

              (value_without_extensions.present? || value_without_extensions == false) &&
                (element_definition[:fixed_value].blank? || value == element_definition[:fixed_value])
            end

            # Note that false.present? => false, which is why we need to add this extra check
            value_found.present? || value_found == false
          end
        end
    end

    def must_support_slices
      metadata.must_supports[:slices]
    end

    def missing_slices(resources = [])
      @missing_slices ||=
        must_support_slices.select do |slice|
          resources.none? do |resource|
            path = slice[:path] # .delete_suffix('[x]')
            find_slice(resource, path, slice[:discriminator]).present?
          end
        end
    end

    def find_slice(resource, path, discriminator)
      find_a_value_at(resource, path) do |element|
        case discriminator[:type]
        when 'patternCodeableConcept'
          coding_path = discriminator[:path].present? ? "#{discriminator[:path]}.coding" : 'coding'
          find_a_value_at(element, coding_path) do |coding|
            coding.code == discriminator[:code] && coding.system == discriminator[:system]
          end
        when 'patternCoding'
          coding_path = discriminator[:path].present? ? discriminator[:path] : ''
          find_a_value_at(element, coding_path) do |coding|
            coding.code == discriminator[:code] && coding.system == discriminator[:system]
          end
        when 'patternIdentifier'
          find_a_value_at(element, discriminator[:path]) { |identifier| identifier.system == discriminator[:system] }
        when 'value'
          values = discriminator[:values].map { |value| value.merge(path: value[:path].split('.')) }
          find_slice_by_values(element, values)
        when 'type'
          case discriminator[:code]
          when 'Date'
            begin
              Date.parse(element)
            rescue ArgumentError
              false
            end
          when 'String'
            element.is_a? String
          else
            element.is_a? FHIR.const_get(discriminator[:code])
          end
        end
      end
    end

    def find_slice_by_values(element, value_definitions)
      path_prefixes = value_definitions.map { |value_definition| value_definition[:path].first }.uniq
      Array.wrap(element).find do |el|
        path_prefixes.all? do |path_prefix|
          value_definitions_for_path =
            value_definitions
              .select { |value_definition| value_definition[:path].first == path_prefix }
              .each { |value_definition| value_definition[:path].shift }

          find_a_value_at(el, path_prefix) do |el_found|
            child_element_value_definitions, current_element_value_definitions =
              value_definitions_for_path.partition { |value_definition| value_definition[:path].present? }

            current_element_values_match =
              current_element_value_definitions
                .all? { |value_definition| value_definition[:value] == el_found }

            child_element_values_match =
              child_element_value_definitions.present? ?
                find_slice_by_values(el_found, child_element_value_definitions) : true

            current_element_values_match && child_element_values_match
          end
        end
      end
    end
  end
end
