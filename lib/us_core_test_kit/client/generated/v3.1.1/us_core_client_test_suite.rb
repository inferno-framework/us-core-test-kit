# frozen_string_literal: true

require 'udap_security_test_kit'
require 'smart_app_launch_test_kit'
require_relative '../../../version'
require_relative 'tags'
require_relative 'urls'
require_relative '../../metadata_helper'
require_relative 'authorization_endpoint'
require_relative 'token_endpoint'
require_relative 'read_endpoint'
require_relative 'search_endpoint'
require_relative '../../test_helper'
require_relative '../../us_core_client_options'
require_relative 'registration_group'
require_relative 'wait_group'
require_relative 'auth_smart_alca_group'
require_relative 'auth_smart_alcs_group'
require_relative 'auth_smart_alp_group'
require_relative 'auth_udap_group'
require_relative 'patient_client_group'
require_relative 'allergy_intolerance_client_group'
require_relative 'care_plan_client_group'
require_relative 'care_team_client_group'
require_relative 'condition_client_group'
require_relative 'device_client_group'
require_relative 'diagnostic_report_note_client_group'
require_relative 'diagnostic_report_lab_client_group'
require_relative 'document_reference_client_group'
require_relative 'goal_client_group'
require_relative 'immunization_client_group'
require_relative 'medication_request_client_group'
require_relative 'smokingstatus_client_group'
require_relative 'pediatric_weight_for_height_client_group'
require_relative 'observation_lab_client_group'
require_relative 'pediatric_bmi_for_age_client_group'
require_relative 'pulse_oximetry_client_group'
require_relative 'head_circumference_client_group'
require_relative 'bodyheight_client_group'
require_relative 'bodytemp_client_group'
require_relative 'bp_client_group'
require_relative 'bodyweight_client_group'
require_relative 'heartrate_client_group'
require_relative 'resprate_client_group'
require_relative 'procedure_client_group'
require_relative 'encounter_client_group'
require_relative 'organization_client_group'
require_relative 'practitioner_client_group'
require_relative 'provenance_client_group'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class USCoreClientTestSuite < Inferno::TestSuite
        include URLs

        id :us_core_client_v311

        title 'US Core Client v3.1.1'

        description %(
          
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

* **Patient**
  * id: us-core-client-tests-patient
* **AllergyIntolerance**
  * id: us-core-client-tests-allergy-intolerance
* **CarePlan**
  * id: us-core-client-tests-care-plan
* **CareTeam**
  * id: us-core-client-tests-care-team
* **Condition**
  * id: us-core-client-tests-condition
* **Device**
  * id: us-core-client-tests-device
* **DiagnosticReportNote**
  * id: us-core-client-tests-diagnostic-report-note
* **DiagnosticReportLab**
  * id: us-core-client-tests-diagnostic-report-lab
* **DocumentReference**
  * id: us-core-client-tests-document-reference
* **Goal**
  * id: us-core-client-tests-goal
* **Immunization**
  * id: us-core-client-tests-immunization
* **MedicationRequest**
  * id: us-core-client-tests-medication-request
* **Smokingstatus**
  * id: us-core-client-tests-smokingstatus
* **PediatricWeightForHeight**
  * id: us-core-client-tests-pediatric-weight-for-height
* **ObservationLab**
  * id: us-core-client-tests-observation-lab
* **PediatricBmiForAge**
  * id: us-core-client-tests-pediatric-bmi-for-age
* **PulseOximetry**
  * id: us-core-client-tests-pulse-oximetry
* **HeadCircumference**
  * id: us-core-client-tests-head-circumference
* **Bodyheight**
  * id: us-core-client-tests-bodyheight
* **Bodytemp**
  * id: us-core-client-tests-bodytemp
* **Bp**
  * id: us-core-client-tests-bp
* **Bodyweight**
  * id: us-core-client-tests-bodyweight
* **Heartrate**
  * id: us-core-client-tests-heartrate
* **Resprate**
  * id: us-core-client-tests-resprate
* **Procedure**
  * id: us-core-client-tests-procedure
* **Encounter**
  * id: us-core-client-tests-encounter
* **Organization**
  * id: us-core-client-tests-organization
* **Practitioner**
  * id: us-core-client-tests-practitioner
* **Provenance**
  * id: us-core-client-tests-provenance

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


        )

        links [
          {
            type: 'report_issue',
            label: 'Report Issue',
            url: 'https://github.com/inferno-framework/us-core-test-kit/issues/'
          },
          {
            type: 'source_code',
            label: 'Open Source',
            url: 'https://github.com/inferno-framework/us-core-test-kit/'
          },
          {
            type: 'download',
            label: 'Download',
            url: 'https://github.com/inferno-framework/us-core-test-kit/releases/'
          }
        ]

        suite_option  :client_type,
                      title: 'Client Security Type',
                      list_options: [
                        {
                          label: 'SMART App Launch Public Client',
                          value: USCoreClientOptions::SMART_APP_LAUNCH_PUBLIC
                        },
                        {
                          label: 'SMART App Launch Confidential Symmetric Client',
                          value: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
                        },
                        {
                          label: 'SMART App Launch Confidential Asymmetric Client',
                          value: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
                        },
                        {
                          label: 'UDAP Authorization Code Client',
                          value: USCoreClientOptions::UDAP_AUTHORIZATION_CODE
                        }
                      ]

        route(:get, METADATA_PATH, USCoreTestKit::Client::MetadataHelper.get_metadata('v311'))
        route(:get, UDAPSecurityTestKit::UDAP_DISCOVERY_PATH, lambda { |_env|
          UDAPSecurityTestKit::MockUDAPServer.udap_server_metadata(id)
        })
        route(:get, SMARTAppLaunch::SMART_DISCOVERY_PATH, lambda { |_env|
          SMARTAppLaunch::MockSMARTServer.smart_server_metadata(id)
        })
        route(:get, SMARTAppLaunch::OIDC_DISCOVERY_PATH, ->(_env) {SMARTAppLaunch::MockSMARTServer.openid_connect_metadata(id) }) 
        route(
          :get,
          SMARTAppLaunch::OIDC_JWKS_PATH,
          ->(_env) { [200, { 'Content-Type' => 'application/json' }, [SMARTAppLaunch::OIDCJWKS.jwks_json]] }
        )

        suite_endpoint :post, UDAPSecurityTestKit::REGISTRATION_PATH,
                        UDAPSecurityTestKit::MockUDAPServer::RegistrationEndpoint
        suite_endpoint :post, UDAPSecurityTestKit::TOKEN_PATH, MockUdapSmartServer::TokenEndpoint
        suite_endpoint :get,  UDAPSecurityTestKit::AUTHORIZATION_PATH, MockUdapSmartServer::AuthorizationEndpoint
        suite_endpoint :post, UDAPSecurityTestKit::AUTHORIZATION_PATH, MockUdapSmartServer::AuthorizationEndpoint

        suite_endpoint :post, SEARCH_POST_ROUTE, SearchEndpoint
        suite_endpoint :get, SEARCH_ROUTE, SearchEndpoint
        suite_endpoint :get, READ_ROUTE, ReadEndpoint

        resume_test_route :get, RESUME_PASS_ROUTE do |request|
          request.query_parameters['token']
        end

        group from: :us_core_client_v311_registration

        group do
          title 'Read & Search'

          run_as_group

          group from: :us_core_client_wait_group_v311

          group from: :us_core_client_v311_patient
          group from: :us_core_client_v311_allergy_intolerance
          group from: :us_core_client_v311_care_plan
          group from: :us_core_client_v311_care_team
          group from: :us_core_client_v311_condition
          group from: :us_core_client_v311_device
          group from: :us_core_client_v311_diagnostic_report_note
          group from: :us_core_client_v311_diagnostic_report_lab
          group from: :us_core_client_v311_document_reference
          group from: :us_core_client_v311_goal
          group from: :us_core_client_v311_immunization
          group from: :us_core_client_v311_medication_request
          group from: :us_core_client_v311_smokingstatus
          group from: :us_core_client_v311_pediatric_weight_for_height
          group from: :us_core_client_v311_observation_lab
          group from: :us_core_client_v311_pediatric_bmi_for_age
          group from: :us_core_client_v311_pulse_oximetry
          group from: :us_core_client_v311_head_circumference
          group from: :us_core_client_v311_bodyheight
          group from: :us_core_client_v311_bodytemp
          group from: :us_core_client_v311_bp
          group from: :us_core_client_v311_bodyweight
          group from: :us_core_client_v311_heartrate
          group from: :us_core_client_v311_resprate
          group from: :us_core_client_v311_procedure
          group from: :us_core_client_v311_encounter
          group from: :us_core_client_v311_organization
          group from: :us_core_client_v311_practitioner
          group from: :us_core_client_v311_provenance

          group from: :us_core_client_v311_auth_smart_alca,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
              }
          group from: :us_core_client_v311_auth_smart_alcs,
                required_suite_options: {
                  client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
                }
          group from: :us_core_client_v311_auth_smart_alp,
                required_suite_options: {
                  client_type: USCoreClientOptions::SMART_APP_LAUNCH_PUBLIC
                }
          group from: :us_core_client_v311_auth_udap,
                required_suite_options: {
                  client_type: USCoreClientOptions::UDAP_AUTHORIZATION_CODE
                }
        end
      end
    end
  end
end
