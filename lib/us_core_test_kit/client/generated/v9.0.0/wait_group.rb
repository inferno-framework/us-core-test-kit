# frozen_string_literal: true

require 'smart_app_launch_test_kit'
require_relative 'auth_smart_alca_group'
require_relative 'auth_smart_alcs_group'
require_relative 'auth_smart_alp_group'

module USCoreTestKit
  module Client
    module USCoreClientV900
      class WaitGroup < Inferno::TestGroup
        include URLs

        id :us_core_client_access_group_v900
        title 'Client Access'
        description %(
          During these tests, Inferno will simulate a US Core FHIR Server for the client to
          use to access data. Inferno will wait while the client submits requests and will
          both respond with data and collect the requests for later analysis.
        )

        run_as_group

        def suite_id
          return config.options[:endpoint_suite_id] if config.options[:endpoint_suite_id].present?

          'us_core_client_v900'
        end

        group do
          id :us_core_client_wait_group_v900
          title 'Perform Data Access'

          test do
            id :us_core_client_wait_test_v900
            title 'Wait for Requests'
            description %(
              This test will wait for the client under test to submit requests for resources for
              the US Core v9 profiles, including their required search parameter combinations.
            )

            input :client_id,
                  title: 'Client Id',
                  type: 'text',
                  optional: true,
                  locked: true,
                  description: SMARTAppLaunch::INPUT_CLIENT_ID_DESCRIPTION_LOCKED
            input :smart_launch_urls,
                  title: 'SMART App Launch URL(s)',
                  type: 'textarea',
                  locked: true,
                  optional: true,
                  description: SMARTAppLaunch::INPUT_SMART_LAUNCH_URLS_DESCRIPTION_LOCKED
            input :launch_context,
                  title: 'Launch Context',
                  type: 'textarea',
                  optional: true,
                  description: SMARTAppLaunch::INPUT_LAUNCH_CONTEXT_DESCRIPTION
            input :fhir_user_relative_reference,
                  title: 'FHIR User Relative Reference',
                  type: 'text',
                  optional: true,
                  description: %(
                    A FHIR relative reference (<resource type>/<id>) for the FHIR user record to return
                    when the openid and fhirUser scopes are requested. If populated, ensure that the
                    referenced resource is available in Inferno's simulated FHIR server so that it can
                    be accessed.
                  )

            input_order :launch_context, :fhir_user_relative_reference, :smart_launch_urls, :client_id
            output :launch_key
            config options: { accepts_multiple_requests: true }

            run do
              if smart_launch_urls.present?
                launch_key = SecureRandom.hex(32)
                output(launch_key:)
              end

              wait(
                identifier: client_id,
                message: %(
  Inferno will now wait for the client under test to make the required requests against the following base URL:

  #{fhir_url}

  All requests will be recorded. When finished, the requests will be inspected to ensure that the client under test is making the required requests.
  Requests should target the following patient record:
  - **Resource ID**: `us-core-client-tests-patient`
  - **Name**: ClientTests USCore
  - **Member Identifier**: `us-core-client-tests-patient` (system: `urn:inferno:mrn`)
  - **Date of Birth**: 1940-03-29
  - **Gender**: male

  [Click here](#{resume_pass_url}?token=#{client_id}) when finished.

  Request the target IDs listed in the v9 client setup documentation and exercise
  the required searches for the resource types your client supports. Optional searches
  provide additional feedback. At least one profile group must pass.
                ),
                timeout: 900
              )
            end
          end
        end

        group from: :us_core_client_v900_auth_smart_alca,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
              }
        group from: :us_core_client_v900_auth_smart_alcs,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
              }
        group from: :us_core_client_v900_auth_smart_alp,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_PUBLIC
              }
      end
    end
  end
end
