# frozen_string_literal: true

require_relative '../../generator/read_test_generator'
require_relative '../../generator/naming'
require_relative '../../generator/special_cases'

module USCoreTestKit
  module Client
    class Generator
      class ReadTestGenerator < USCoreTestKit::Generator::ReadTestGenerator
        def template
          @template ||= File.read(File.join(__dir__, 'templates', 'read_test.rb.erb'))
        end

        def group_name
          "#{profile_identifier.camelize}ClientGroup"
        end

        def class_name
          "#{profile_identifier.camelize}ClientReadTest"
        end

        def module_name
          "USCoreClient#{group_metadata.reformatted_version.upcase}"
        end

        def test_id
          "us_core_#{group_metadata.reformatted_version}_#{class_name.underscore}"
        end

        def resource
          group_metadata.resource
        end

        def expected_resource_id
          "us-core-client-tests-#{profile_identifier.underscore.dasherize}"
        end

        def title
          "#{conformance_expectation} support read of #{profile_identifier.camelize}"
        end

        def description
          "The client demonstrates #{conformance_expectation} support for reading #{profile_identifier.camelize}."
        end
      end
    end
  end
end
