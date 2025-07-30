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

            This test group verifies that the client can access #{resource_type} data
            conforming to the #{profile_name}.

            # Testing Methodology

            ## Data Access Supported

            Clients may not be required to support the #{resource_type} FHIR resource type. However, if they
            do support it, they must support the #{profile_name} and the resource type's search parameters.
            The tests in this group will not execute if client makes no attempt to access data for the
            #{resource_type} resource type. In this case, the test will be marked as skip if support
            for the resource type is required, and omitted otherwise.

            ## Reading
            This test will check that the client performed a read of #{expected_resource_id.size > 1 ? 'one of the following ids' : 'the following id'}:

            #{expected_resource_id_string}

            ## Searching
            These tests will check that the client performed searches agains the
            #{resource_type} resource type with the following required parameters:

            #{search_param_name_string}

            Inferno will also look for searches using the following optional parameters:

            #{optional_search_param_name_string}

          DESCRIPTION
        end

        def optional_searches
          group_metadata.searches.select { |search| search[:expectation] != 'SHALL' }
        end

        def optional_search_param_name_string
          optional_searches
            .map { |search| search[:names].join(' + ') }
            .map { |names| "* #{names}" }
            .join("\n")
        end

        def conformance_optional?
          group_metadata.resource_conformance_expectation != 'SHALL'
        end

        def generate
          File.write(output_file_name, output)
          group_metadata.id = group_id
          group_metadata.file_name = base_output_file_name
        end

        def expected_resource_id_string
          expected_resource_id = [ Naming.instance_id_for_profile_identifier(profile_identifier) ]
          if profile_identifier == 'observation_clinical_result'
            expected_resource_id << Naming.instance_id_for_profile_identifier('observation_lab')
          end

          expected_resource_id.map { |id| "* `#{id}`"}.join("\n")
        end
      end
    end
  end
end
