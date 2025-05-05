# frozen_string_literal: true

require_relative '../../generator/group_generator'
require_relative '../../generator/naming'
require_relative '../../generator/special_cases'

module USCoreTestKit
  module Client
    class Generator
      class GroupGenerator < USCoreTestKit::Generator::GroupGenerator
        def template
          @template ||= File.read(File.join(__dir__, 'templates', 'group.rb.erb'))
        end

        def output
          @output ||= ERB.new(template, trim_mode: '-').result(binding)
        end

        def class_name
          "#{profile_identifier.camelize}ClientGroup"
        end

        def module_name
          "USCoreClient#{group_metadata.reformatted_version.upcase}"
        end

        def group_id
          "us_core_client_#{group_metadata.reformatted_version}_#{profile_identifier}"
        end

        def description
          <<~DESCRIPTION

            # Background

            This test group verifies that the client under test is
            able to perform the required #{resource_type} queries.

            # Testing Methodology

            ## Reading
            This sequence will check that the client performed a search with the following ID:

            * `us-core-client-tests-#{profile_identifier.underscore.dasherize}`

            ## Searching
            This sequence will check that the client performed searches with the following parameters:

            #{search_param_name_string}
          DESCRIPTION
        end

        def generate
          File.write(output_file_name, output)
          group_metadata.id = group_id
          group_metadata.file_name = base_output_file_name
        end
      end
    end
  end
end
