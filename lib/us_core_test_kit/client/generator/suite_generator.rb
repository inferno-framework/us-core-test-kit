# frozen_string_literal: true

require_relative '../../generator/suite_generator'
require_relative '../../generator/special_cases'
require_relative 'naming'

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
            to the [US Core Implementation Guide](#{ig_link}).

            # Scope

            These tests are a DRAFT intended to allow implementers to perform preliminary checks
            of their client systems against the requirements stated for US Core Implementation
            Guide and provide feedback on the tests. Future versions of these tests may verify other
            requirements and may change the test verification logic.

            # Test Methodology

            For these tests Inferno simulates the FHIR server containing data for each US Core Profile
            (see the *Available Instances* section below for details on the data served by Inferno).
            During execution, Inferno will wait for the client under test to issue requests and will
            respond to them with the requested data. Inferno will then evaluate the requests in aggregate
            to verify that they demonstrate that the client:

            * Retrieved a target instance for each profile.
            * Performed searches using the required search parameters and search parameter combinations
              for the profile's resource type.

            # Interpreting the Results
             
            These tests will check for support for requesting data for every US Core profile.
            The "Read & Search" group includes a sub-group for each US Core profile. Groups
            for profiles of resources that are required by the US Core Client CapabilityStatement
            are marked as required while groups for others are optional. Each profile group will be
            evaluated on every run through these tests, but feedback will only be provided on
            profiles of resource types that the client makes requests for.
            - If a client makes a request for a given resource type, support for all profiles of that
              resource type will be evaluated, meaning that the group for each profile of that resource
              type will be executed, checking that the client read the target instance for that profile
              and perform searches with all required search parameters and combinations for the resource
              type. The executed group will pass or fail and include details of the issues encountered by
              Inferno.
            - If a client makes no requests for a given resource type, support is not evaluated. If support
              for the resource type is required, the tests will be marked as skiped, forcing an overall
              failure. Otherwise, the tests will be marked as omitted on the assumption that the client
              does not support the optional resource type and profile represented by the group.

            The tests will not pass unless at least one profile group passes.

            # Running the Tests

            ## Quick Start

            Inferno's simulated US Core endpoints require authentication using the OAuth flows
            conforming the SMART [App Launch flow](https://hl7.org/fhir/smart-app-launch/STU2.2/app-launch.html).

            When creating a test session, select the Client Security Type corresponding to an
            authentication approach supported by the client. Then, start by running the "Client Registration"
            group which will guide you through the registration process, including what inputs to provide.
            See the *Auth Configuration Details* section below for details.

            Once registration is complete, run the "Read & Search" group to activate Inferno's
            simulated US Core server, allowing it to wait for US Core read and search requests
            from the client and return the requested US Core resources. The Patient that the client
            needs to request data for has the following demographic details:
            - **Resource ID**: `us-core-client-tests-patient`
            - **Name**: ClientTests USCore
            - **Member Identifier**: `us-core-client-tests-patient` (system: `urn:inferno:mrn`)
            - **Date of Birth**: 1940-03-29
            - **Gender**: male

            While waiting, Inferno will display a "User Action Needed" dialog with the above details and
            more. Once the client has made all the requests, click the link in that dialog to have
            Inferno evaluate the requests made.

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
               These tests will run for a while. Most groups will skip due to incomplete coverage of must support
               elements in the client test's data set.
            5. Once the server tests have completed, return to the client test session and click the link
               in the "User Action Required" dialog to continue the tests and evaluate the client's
               interactions. These tests will also run for a while and may result in some failures or skips.

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

            # Available Instances
             
            Inferno's simulated US Core server includes the following target instances for the test patient

            #{profiles_description}

            # Current Limitations

            This test suite is still in draft form and does not test all of the client requirements and features
            described in the US Core Implementation guide.

            The current version of this test suite supports the following tests using a specific Inferno-specified patient:
            - Testing a client's ability to perform read requests against a FHIR server for all US Core Profiles
              listed in the [US Core Client CapabilityStatement](#{ig_link}/CapabilityStatement-us-core-client.html).
            - Testing a client's ability to perform searches using search parameters and combinations
              listed for each resource type in the [US Core Client CapabilityStatement](#{ig_link}/CapabilityStatement-us-core-client.html).

            The current version of this test suite does not:
            - Support esting searches with/via:
              - date comparator
              - multiple-OR
              - _revInclude
            - Verify that date and dateTime search parameter values are provided at the required level of precision.
            - Check the Must Support Conformance Requirements for clients/requestors specified in US Core IG #{ig_metadata.ig_version}
            - Support clients that cannot follow the SMART App Launch OAuth flow to obtain an access token.
            - Allow testers to bring their own data. Testers must manually configure their client system to connect
              to a specific target patient and must access and process specific curated sample US Core data.

          DESCRIPTION
        end

        def read_and_search_description
          <<~DESCRIPTION
            
            During these tests, the US Core client system will interact with Inferno's simulated US Core Server
            and demonstrate its ability to perform the FHIR interactions described in the [US Core Client CapabilityStatement](#{ig_link}/CapabilityStatement-us-core-client.html).
          
          DESCRIPTION
        end

        def profiles_description
          groups
            .map do |group|
              profile = USCoreTestKit::Generator::Naming.snake_case_for_profile(group)
              "* **[#{group.profile_name}](#{group.profile_url}|#{group.profile_version})** (id: #{Naming.instance_id_for_profile_identifier(profile)})"
            end
            .join("\n")
        end

        def access_group_id
          "us_core_client_access_group_#{ig_metadata.reformatted_version.downcase}"
        end

        def registration_group_id
          "us_core_client_#{ig_metadata.reformatted_version.downcase}_registration"
        end
      end
    end
  end
end
