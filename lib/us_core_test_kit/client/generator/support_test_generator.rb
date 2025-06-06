# frozen_string_literal: true

require_relative '../../generator/naming'
require_relative '../../generator/special_cases'
require_relative 'naming'

module USCoreTestKit
  module Client
    class Generator
      class SupportTestGenerator
        class << self
          def generate(ig_metadata, base_output_dir)
            ig_metadata.groups
                       .reject { |group| USCoreTestKit::Generator::SpecialCases.exclude_group? group }
                       .select { |group| group.searches.present? || read_interaction(group).present? }
                       .each { |group| new(group, base_output_dir).generate }
          end
          
          def read_interaction(group_metadata)
            group_metadata.interactions.find { |interaction| interaction[:code] == 'read' }
          end
        end

        attr_accessor :group_metadata, :base_output_dir

        def initialize(group_metadata, base_output_dir)
          self.group_metadata = group_metadata
          self.base_output_dir = base_output_dir
        end
        
        def template
          @template ||= File.read(File.join(__dir__, 'templates', 'support_test.rb.erb'))
        end

        def group_name
          "#{profile_identifier.camelize}ClientGroup"
        end

        def class_name
          "#{profile_identifier.camelize}ClientSupportTest"
        end

        def module_name
          "USCoreClient#{group_metadata.reformatted_version.upcase}"
        end

        def test_id
          "us_core_#{group_metadata.reformatted_version}_#{class_name.underscore}"
        end

        def resource_type
          group_metadata.resource
        end

        def profile_identifier
          USCoreTestKit::Generator::Naming.snake_case_for_profile(group_metadata)
        end

        def title
          "Support #{resource_type} Resource Access"
        end

        def expected_resource_id
          Naming.instance_id_for_profile_identifier(profile_identifier)
        end

        def description
          %(
            This test checks whether the client made requests for the #{resource_type} FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `#{expected_resource_id}` for the #{group_metadata.profile_name}.
          )
        end

        def output
          @output ||= ERB.new(template).result(binding)
        end

        def base_output_file_name
          "#{class_name.underscore}.rb"
        end

        def output_file_directory
          File.join(base_output_dir, profile_identifier)
        end

        def output_file_name
          File.join(output_file_directory, base_output_file_name)
        end

        def generate
          FileUtils.mkdir_p(output_file_directory)
          File.open(output_file_name, 'w') { |f| f.write(output) }

          group_metadata.add_test(
            id: test_id,
            file_name: base_output_file_name
          )
        end
      end
    end
  end
end
