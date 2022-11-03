module USCoreTestKit
  class Generator
    class ValueExactor
      attr_accessor :ig_resources, :resource

      def initialize(ig_resources, resource)
        self.ig_resources = ig_resources
        self.resource = resource
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