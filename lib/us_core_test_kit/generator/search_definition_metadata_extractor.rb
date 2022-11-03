require_relative 'value_extractor'

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
          value_extractor.values_from_slicing(profile_element, type).presence ||
          value_extractor.values_from_value_set_binding(profile_element).presence ||
          value_extractor.values_from_resource_metadata(paths).presence || []
      end

      def value_extractor
        @value_extractor ||= ValueExactor.new(ig_resources, resource, profile_elements)
      end
    end
  end
end
