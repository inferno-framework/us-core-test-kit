# frozen_string_literal: true

require_relative '../../generator/search_test_generator'
require_relative '../../generator/naming'
require_relative '../../generator/special_cases'

module USCoreTestKit
  module Client
    class Generator
      class SearchTestGenerator < USCoreTestKit::Generator::SearchTestGenerator
        class << self
          def generate(ig_metadata, base_output_dir)
            ig_metadata.groups
                       .reject { |group| USCoreTestKit::Generator::SpecialCases.exclude_group? group }
                       .select { |group| group.searches.present? }
                       .each do |group|
              group.searches.each do |search|
                new(group, search, base_output_dir).generate
              end
            end
          end
        end

        def template
          @template ||= File.read(File.join(__dir__, 'templates', 'search_test.rb.erb'))
        end

        def group_name
          "#{profile_identifier.camelize}ClientGroup"
        end

        def class_name
          "#{profile_identifier.camelize}#{search_identifier.camelize}ClientSearchTest"
        end

        def resource
          group_metadata.resource
        end

        def module_name
          "USCoreClient#{group_metadata.reformatted_version.upcase}"
        end

        def test_id
          "us_core_#{group_metadata.reformatted_version}_#{class_name.underscore}"
        end

        def title
          "#{conformance_expectation} support #{search_param_name_string} search of #{profile_identifier.camelize}"
        end

        def description
          "The client demonstrates #{conformance_expectation} support for searching #{search_param_name_string} on #{profile_identifier.camelize}."
        end
      end
    end
  end
end
