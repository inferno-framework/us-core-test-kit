module USCoreTestKit
  class Generator
    class ValueExactor
      attr_accessor :ig_resources, :resource, :profile_elements, :profile_element

      def initialize(ig_resources, resource, profile_elements)
        self.ig_resources = ig_resources
        self.resource = resource
        self.profile_elements = profile_elements
      end

      def values_from_slicing(profile_element, type)
        (
          values_from_required_binding(profile_element) +
          values_from_fixed_codes(profile_element, type) +
          values_from_pattern_coding(profile_element, type) +
          values_from_pattern_codeable_concept(profile_element, type)
        ).uniq
      end

      def values_from_required_binding(profile_element)
        return [] unless profile_element&.max == '*'

        profile_elements
          .select do |element|
            element.path == profile_element.path && element.binding&.strength == 'required'
          end
          .map { |element| values_from_value_set_binding(element) }
          .flatten.compact
      end

      def values_from_fixed_codes(profile_element, type)
        return [] unless type == 'CodeableConcept'

        profile_elements
          .select do
            |element| element.path == "#{profile_element.path}.coding.code" && element.fixedCode.present?
          end
          .map { |element| element.fixedCode }
      end

      def values_from_pattern_coding(profile_element, type)
        return [] unless type == 'CodeableConcept'

        profile_elements
          .select { |element| element.path == "#{profile_element.path}.coding" && element.patternCoding.present? }
          .map { |element| element.patternCoding.code }
      end

      def values_from_pattern_codeable_concept(profile_element, type)
        return [] if type != 'CodeableConcept'

        profile_elements
          .select { |element| element.path == profile_element.path && element.patternCodeableConcept.present? }
          .map { |element| element.patternCodeableConcept.coding.first.code }
      end

      def value_set_binding(the_element)
        the_element&.binding
      end

      def value_set(the_element)
        ig_resources.value_set_by_url(value_set_binding(the_element)&.valueSet)
      end

      def bound_systems(the_element)
        value_set(the_element)&.compose&.include&.reject { |code| code.concept.nil? }
      end

      def values_from_value_set_binding(the_element)
        bound_systems = bound_systems(the_element)

        return [] if bound_systems.blank?

        bound_systems.flat_map { |system| system.concept.map { |code| code.code } }.uniq
      end

      def fhir_metadata(current_path)
        FHIR.const_get(resource)::METADATA[current_path]
      end

      def values_from_resource_metadata(paths)
        values = []

        paths.each do |current_path|
          current_metadata = fhir_metadata(current_path)

          if current_metadata&.dig('valid_codes').present?
            values = values + current_metadata['valid_codes'].values.flatten
          end
        end

        values
      end
    end
  end
end