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

            Inferno's simulated US Core endpoints require authentication using the OAuth flows
            conforming the SMART [App Launch flow](https://hl7.org/fhir/smart-app-launch/STU2.2/app-launch.html).

            When creating a test session, select the Client Security Type corresponding to an
            authentication approach supported by the client. Then, start by running the "Client Registration"
            group which will guide you through the registration process, including what inputs to provide.
            See the *Auth Configuration Details* section below for details.

            Once registration is complete, run the "Read & Search" group to have Inferno wait for US Core
            read and search requests from the client, return the requested US Core
            resources to the client, and verify the interactions. The Patient that the client
            needs to request data for has the following demographic details:
            - **Resource ID**: `us-core-client-tests-patient`
            - **Name**: ClientTests USCore
            - **Member Identifier**: `us-core-client-tests-patient` (system: `urn:inferno:mrn`)
            - **Date of Birth**: 1940-03-29
            - **Gender**: male

            ## Demonstration

            To try out these tests without an actual US Core client implementation, you may run them against
            the US Core Server tests using the following steps:

            1. In separate tabs, create test sessions for corresponding versions of
               - The "US Core" test suite, choosing the "SMART App Launch 2.2.0" option
               - The "US Core Client" test suite, choosing the "SMART App Launch Public Client" option
            2. In the US Core Client test session, select the "Demo: Run Against the US Core Server Suite"
               preset in the upper left, click the "RUN ALL TESTS" button in the upper right, and then click
               "SUBMIT" at the bottom of the input dialog that appears. Confirm the configuration of the client
               by clicking the link in the first "User Action Required" dialog that appears, so that a second
               one appears asking for US Core requests to be made.
            3. In the US Core Server test session, select the "Standalone Launch" group from the list
               at the left, select the "Demo: Run Against the US Core Client Suite"
               preset in the upper left, click the "RUN TESTS" button in the upper right, and then click
               "SUBMIT" at the bottom of the input dialog that appears. When a "User Action Required" dialog
               appears, click the link to authorize with the server and the test run will complete. A few tests
               may fail.
            4. Select the "US Core FHIR API" group from the list at the left, click the "RUN ALL TESTS" button
               in the upper right, and then click "SUBMIT" at the bottom of the input dialog that appears.
               These tests will run for a while and may result in test failures around must support and
               conformance features.
            5. Once the server tests have completed, return to the client test session and click the link
               in the "User Action Required" dialog to continue the tests and evaluate the client's
               interactions. These tests will also run for a while and may result in some failures.

            # Input Details

            ## Auth Configuration Details

            When running these tests there are 3 options for SMART authentication, which also allows
            Inferno to identify which session the requests are for. The choice is made when the
            session is created with the selected Client Security Type option, which determines
            what details the tester needs to provide during manual SMART registration with Inferno.

            In all cases, testers will provide:
            - One or more redirect URI(s) in the **SMART App Launch Redirect URI(s)** input.
            - Zero or more launch URL(s) in the **SMART App Launch URL(s)** input.
            - Optionally, a **Client Id** if they want their client assigned a specific id. 
              
            Depending on the specific SMART flavor chosen, additional inputs for authentication may be needed:
            - **SMART App Launch Public Client**: no additional authentication inputs
            - **SMART App Launch Confidential Symmetric Client**: provide a secret using the
              **SMART Confidential Symmetric Client Secret** input.
            - **SMART App Launch Confidential Asymmetric Client**: provide a URL that resolves
              to a JWKS or a raw JWKS in JSON format using the **SMART JSON Web Key Set (JWKS)** input.

            ## Inputs Controlling Token Responses

            Inferno's SMART simulation does not include the details needed to populate
            the token response [context data](https://hl7.org/fhir/smart-app-launch/STU2.2/scopes-and-launch-context.html)
            when requested by apps using scopes during the *SMART App Launch* flow. If the tested app
            needs and will request these details, the tester must provide them for Inferno
            to respond with using the following inputs:
            - **Launch Context**: Testers can provide a JSON
              array for Inferno to use as the base for building a token response on. This can include
              keys like `"patient"` when the `launch/patient` scope will be requested. Note that when keys that Inferno
              also populates (e.g. `access_token` or `id_token`) are included, the Inferno value will be returned.
            - **FHIR User Relative Reference**: Testers
              can provide a FHIR relative reference (`<resource type>/<id>`) for the FHIR user record
              to return with the `id_token` when the `openid` and `fhirUser` scopes are requested.
              If populated, ensure that the referenced resource is available in Inferno's simulated
              FHIR server so that it can be accessed.

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
            - The Must Support Conformance Requirements for clients/requestors specified in US Core IG #{ig_metadata.ig_version}
            - Clients that cannot follow the SMART App Launch OAuth flow to obtain an access token.

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

        def registration_group_id
          "us_core_client_#{ig_metadata.reformatted_version.downcase}_registration"
        end
      end
    end
  end
end
