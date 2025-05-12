# frozen_string_literal: true

require_relative '../../generator/suite_generator'
require_relative '../../generator/special_cases'

module USCoreTestKit
  module Client
    class Generator
      class SuiteGenerator < USCoreTestKit::Generator::SuiteGenerator
        def template
          @template ||= File.read(File.join(__dir__, 'templates', 'suite.rb.erb'))
        end

        def output
          @output ||= ERB.new(template, trim_mode: '-').result(binding)
        end

        def base_output_file_name
          'us_core_client_test_suite.rb'
        end

        def class_name
          'USCoreClientTestSuite'
        end

        def module_name
          "USCoreClient#{ig_metadata.reformatted_version.upcase}"
        end

        def group_ids
          groups
            .map do |group|
              "#{USCoreTestKit::Generator::Naming.snake_case_for_profile(group)}ClientGroup".underscore
            end
        end

        def group_names
          group_ids.map(&:camelize)
        end

        def suite_id
          "us_core_client_#{ig_metadata.reformatted_version}"
        end

        def title
          "US Core Client #{ig_metadata.ig_version}"
        end

        def description
          <<~DESCRIPTION

            The US Core Test Kit Client Suite tests client systems for their conformance
            to the US Core Implementation Guide.

            # Scope

            These tests are a DRAFT intended to allow implementers to perform preliminary checks
            of their client systems against the requirements stated for US Core Implementation
            Guide and provide feedback on the tests. Future versions of these tests may verify other
            requirements and may change the test verification logic.

            # Test Methodology

            For these tests Inferno simulates the FHIR server. Inferno's simulated server contains
            data for each of the following US Core Profiles:

            #{profiles_description}

            During execution, Inferno will wait for the client under test to issue requests and will
            respond to them with the requested data. Inferno will then evaluate the requests in aggregate
            to verify that they demonstrate that the client:

            * Retrieved instances of each profile
            * Performed searches using the required search parameters and search parameter combinations

            # Running the Tests

            ## Quick Start

            Inferno needs to be able to identify when requests come from the client under test. Testers
            must provide a bearer access token that will be provided within the Authentication header
            (Bearer <token>) on all requests made to Inferno endpoints during the test. Inferno uses this
            information to associate the message with the test session and determine how to respond. How
            the token provided to Inferno is generated is up to the tester.

            Note: authentication options for these tests have not been finalized and are subject to change
            as the requirements evolve. If the implemented approach prevents you from using these tests,
            please provide feedback so the limitations can be addressed.

            ## Sample Execution

            To try out these tests without an actual US Core client implementation, you may run them using the
            [included Ruby script](https://github.com/inferno-framework/us-core-test-kit/blob/main/lib/us-core-test-kit/client/docs/us_core_client.rb).
            This script will simulate a client by making requests to Inferno. Set the access token to "test".

            # Current Limitations

            This test suite is still in draft form and does not test all of the client requirements and features
            described in the US Core Implementation guide.

            The current version of this test suite supports:
            - Testing a client's ability to perform read requests against a FHIR server for all US Core Profiles
            summarized in the US Core Capability Statement.
            - Testing a client's ability to perform searches using the SHALL conformance search parameters
            summarized in the US Core Capability Statement.

            The current version of this test suite does not support:
            - Testing searches with/via:
              - date comparator
              - multiple-OR
              - _revInclude
              - The client SHALL provide values precise to the day for elements of datatype date and to the second + time offset for elements of datatype dateTime.
            - Other must support requirements not outlined above.

          DESCRIPTION
        end

        def profiles_description
          groups
            .map do |group|
              profile = USCoreTestKit::Generator::Naming.snake_case_for_profile(group)
              "* **#{profile.camelize}**\n  * id: us-core-client-tests-#{profile.underscore.dasherize}"
            end
            .join("\n")
        end

        def wait_group_id
          "us_core_client_wait_group_#{ig_metadata.reformatted_version.downcase}"
        end
      end
    end
  end
end
