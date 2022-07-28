module USCoreTestKit
  class Generator
    class SearchDefinitionMetadataExtractor
      attr_accessor :ig_resources, :name, :resource, :profile_elements

      def initialize(name, ig_resources, resource, profile_elements)
        self.name = name
        self.ig_resources = ig_resources
        self.resource = resource
        self.profile_elements = profile_elements
      end

      def search_definition
        @search_definition ||=
          {
            paths: paths,
            full_paths: full_paths,
            comparators: comparators,
            values: values,
            type: type,
            contains_multiple: contains_multiple?,
            multiple_or: multiple_or_expectation,
            chain: chain
          }.compact
      end

      def param
        @param ||= ig_resources.search_param_by_resource_and_name(resource, name)
      end

      def param_hash
        param.source_hash
      end

      def full_paths
        @full_paths ||=
          begin
            path = param.expression.gsub(/.where\((.*)/, '')
            path = path[1..-2] if path.start_with?('(') && path.end_with?(')')
            path.scan(/[. ]as[( ]([^)]*)[)]?/).flatten.map do |as_type|
              path.gsub!(/[. ]as[( ](#{as_type}[^)]*)[)]?/, as_type.upcase_first) if as_type.present?
            end
            path.split('|')
          end
      end

      def paths
        @paths ||= full_paths.map { |a_path| a_path.gsub("#{resource}.", '') }
      end

      def profile_element
        @profile_element ||=
          profile_elements.find { |element| full_paths.include?(element.id) }
      end

      def comparator_expectation_extensions
        @comparator_expectation_extensions ||= param_hash['_comparator'] || []
      end

      def support_expectation(extension)
        extension['extension'].first['valueCode']
      end

      def comparator_expectation(extension)
        if extension.nil?
          'MAY'
        else
          support_expectation(extension)
        end
      end

      def comparators
        {}.tap do |comparators|
          param.comparator&.each_with_index do |comparator, index|
            comparators[comparator.to_sym] = comparator_expectation(comparator_expectation_extensions[index])
          end
        end
      end

      def type
        if profile_element.present?
          profile_element.type.first.code
        else
          # search is a variable type, eg. Condition.onsetDateTime - element
          # in profile def is Condition.onset[x]
          param.type
        end
      end

      def contains_multiple?
        profile_element&.max == '*'
      end

      def chain_extensions
        param_hash['_chain']
      end

      def chain_expectations
        chain_extensions.map { |extension| support_expectation(extension) }
      end

      def chain
        return nil if param.chain.blank?

        param.chain
          .zip(chain_expectations)
          .map { |chain, expectation| { chain: chain, expectation: expectation } }
      end

      def multiple_or_expectation
        param_hash['_multipleOr']['extension'].first['valueCode']
      end

      def values
        values = (
          (
            values_from_pattern_codeable_concept_slices +
            values_from_required_binding_slices +
            values_from_fixed_codes +
            values_from_pattern_coding +
            values_from_pattern_codeable_concept
          ).uniq.presence || values_from_value_set_binding(profile_element)
        ).presence || values_from_resource_metadata
        values
      end

      def slices
        return [] unless contains_multiple?

        profile_elements.select do |element|
          full_paths.include?(element.path) &&
            element.sliceName.present? &&
            (
              element.patternCodeableConcept.present? ||
              element.binding.present? && element.binding.strength == 'required'
            )
        end
      end

      def values_from_pattern_codeable_concept_slices
        slices.map do |slice|
          slice.patternCodeableConcept.coding.first.code if slice.patternCodeableConcept.present?
        end.compact
      end

      def values_from_required_binding_slices
        slices.map do |slice|
          if slice.binding.present? && slice.binding.strength == 'required'
            values_from_value_set_binding(slice)
          end
        end.flatten.compact
      end

      def values_from_fixed_codes
        return [] unless type == 'CodeableConcept'

        profile_elements
          .select { |element| element.path == "#{profile_element.path}.coding.code" && element.fixedCode.present? }
          .map { |element| element.fixedCode }
      end

      def values_from_pattern_coding
        return [] unless type == 'CodeableConcept'

        profile_elements
          .select { |element| element.path == "#{profile_element.path}.coding" && element.patternCoding.present? }
          .map { |element| element.patternCoding.code }
      end

      def values_from_pattern_codeable_concept
        return [] if type != 'CodeableConcept' || profile_element.patternCodeableConcept.blank?

        [profile_element.patternCodeableConcept.coding.first.code]
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

      def values_from_resource_metadata
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
