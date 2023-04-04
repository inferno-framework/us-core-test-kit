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
            path = param.expression.gsub(/.where\(resolve\((.*)/, '').gsub(/url = '/, 'url=\'')
            path = path[1..-2] if path.start_with?('(') && path.end_with?(')')
            path.scan(/[. ]as[( ]([^)]*)[)]?/).flatten.map do |as_type|
              path.gsub!(/[. ]as[( ](#{as_type}[^)]*)[)]?/, as_type.upcase_first) if as_type.present?
            end

            full_paths = path.split('|')

            # There is a bug in US Core 5 asserted-date search parameter. See FHIR-40573
            if param.respond_to?(:version) && param.version == '5.0.1' && name == 'asserted-date'
              remove_additional_extension_from_asserted_date(full_paths)
            end

            full_paths
          end
      end

      def remove_additional_extension_from_asserted_date(full_paths)
        full_paths.each do |full_path|
          next unless full_path.include?('http://hl7.org/fhir/StructureDefinition/condition-assertedDate')
          full_path.gsub!(/\).extension./, ').')
        end
      end

      def paths
        @paths ||= full_paths.map { |a_path| a_path.gsub("#{resource}.", '') }
      end

      def extensions
        @extensions ||= full_paths.select { |a_path| a_path.include?('extension.where') }
                                  .map { |a_path| { url: a_path[/(?<=extension.where\(url=').*(?='\))/] }}
                                  .presence
      end

      def profile_element
        @profile_element ||=
          (
            profile_elements.find { |element| full_paths.include?(element.id) } ||
            extension_definition&.differential&.element&.find { |element| element.id == 'Extension.value[x]'}
          )
      end

      def extension_definition
         @extension_definition ||=
            begin
              ext_definition = nil
              extensions&.each do |ext_metadata|
                ext_definition = ig_resources.profile_by_url(ext_metadata[:url])
                break if ext_definition.present?
              end
              ext_definition
            end
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
        if profile_element.present?
          if profile_element.id.start_with?('Extension') && extension_definition.present?
            # Find the extension instance in a US Core profile
            target_element = profile_elements.find do |element|
              element.type.any? { |type| type.code == "Extension" && type.profile.include?(extension_definition.url) }
            end
            target_element&.max == '*'
          else
            profile_element.max == '*'
          end
        else
          false
        end
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
          value_extractor.values_from_required_binding(profile_element).presence ||
          value_extractor.values_from_value_set_binding(profile_element).presence ||
          values_from_resource_metadata(paths).presence ||
          []
      end

      def values_from_resource_metadata(paths)
        if multiple_or_expectation == 'SHALL' || paths.any? { |path| path.downcase.include?('status') }
          value_extractor.values_from_resource_metadata(paths)
        else
          []
        end
      end

      def value_extractor
        @value_extractor ||= ValueExactor.new(ig_resources, resource, profile_elements)
      end
    end
  end
end
