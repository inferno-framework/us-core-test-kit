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
require_relative 'condition_encounter_diagnosis_client_group'
require_relative 'condition_problems_health_concerns_client_group'
require_relative 'device_client_group'
require_relative 'diagnostic_report_note_client_group'
require_relative 'diagnostic_report_lab_client_group'
require_relative 'document_reference_client_group'
require_relative 'encounter_client_group'
require_relative 'goal_client_group'
require_relative 'immunization_client_group'
require_relative 'medication_request_client_group'
require_relative 'observation_lab_client_group'
require_relative 'observation_sdoh_assessment_client_group'
require_relative 'respiratory_rate_client_group'
require_relative 'observation_social_history_client_group'
require_relative 'heart_rate_client_group'
require_relative 'body_temperature_client_group'
require_relative 'pediatric_weight_for_height_client_group'
require_relative 'pulse_oximetry_client_group'
require_relative 'smokingstatus_client_group'
require_relative 'observation_sexual_orientation_client_group'
require_relative 'head_circumference_client_group'
require_relative 'body_height_client_group'
require_relative 'bmi_client_group'
require_relative 'blood_pressure_client_group'
require_relative 'observation_imaging_client_group'
require_relative 'observation_clinical_test_client_group'
require_relative 'pediatric_bmi_for_age_client_group'
require_relative 'head_circumference_percentile_client_group'
require_relative 'body_weight_client_group'
require_relative 'procedure_client_group'
require_relative 'questionnaire_response_client_group'
require_relative 'service_request_client_group'
require_relative 'organization_client_group'
require_relative 'practitioner_client_group'
require_relative 'practitioner_role_client_group'
require_relative 'provenance_client_group'
require_relative 'related_person_client_group'

module USCoreTestKit
  module Client
    module USCoreClientV501
      class USCoreClientTestSuite < Inferno::TestSuite
        include URLs

        id :us_core_client_v501

        title 'US Core Client v5.0.1'

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
* **ConditionEncounterDiagnosis**
  * id: us-core-client-tests-condition-encounter-diagnosis
* **ConditionProblemsHealthConcerns**
  * id: us-core-client-tests-condition-problems-health-concerns
* **Device**
  * id: us-core-client-tests-device
* **DiagnosticReportNote**
  * id: us-core-client-tests-diagnostic-report-note
* **DiagnosticReportLab**
  * id: us-core-client-tests-diagnostic-report-lab
* **DocumentReference**
  * id: us-core-client-tests-document-reference
* **Encounter**
  * id: us-core-client-tests-encounter
* **Goal**
  * id: us-core-client-tests-goal
* **Immunization**
  * id: us-core-client-tests-immunization
* **MedicationRequest**
  * id: us-core-client-tests-medication-request
* **ObservationLab**
  * id: us-core-client-tests-observation-lab
* **ObservationSdohAssessment**
  * id: us-core-client-tests-observation-sdoh-assessment
* **RespiratoryRate**
  * id: us-core-client-tests-respiratory-rate
* **ObservationSocialHistory**
  * id: us-core-client-tests-observation-social-history
* **HeartRate**
  * id: us-core-client-tests-heart-rate
* **BodyTemperature**
  * id: us-core-client-tests-body-temperature
* **PediatricWeightForHeight**
  * id: us-core-client-tests-pediatric-weight-for-height
* **PulseOximetry**
  * id: us-core-client-tests-pulse-oximetry
* **Smokingstatus**
  * id: us-core-client-tests-smokingstatus
* **ObservationSexualOrientation**
  * id: us-core-client-tests-observation-sexual-orientation
* **HeadCircumference**
  * id: us-core-client-tests-head-circumference
* **BodyHeight**
  * id: us-core-client-tests-body-height
* **Bmi**
  * id: us-core-client-tests-bmi
* **BloodPressure**
  * id: us-core-client-tests-blood-pressure
* **ObservationImaging**
  * id: us-core-client-tests-observation-imaging
* **ObservationClinicalTest**
  * id: us-core-client-tests-observation-clinical-test
* **PediatricBmiForAge**
  * id: us-core-client-tests-pediatric-bmi-for-age
* **HeadCircumferencePercentile**
  * id: us-core-client-tests-head-circumference-percentile
* **BodyWeight**
  * id: us-core-client-tests-body-weight
* **Procedure**
  * id: us-core-client-tests-procedure
* **QuestionnaireResponse**
  * id: us-core-client-tests-questionnaire-response
* **ServiceRequest**
  * id: us-core-client-tests-service-request
* **Organization**
  * id: us-core-client-tests-organization
* **Practitioner**
  * id: us-core-client-tests-practitioner
* **PractitionerRole**
  * id: us-core-client-tests-practitioner-role
* **Provenance**
  * id: us-core-client-tests-provenance
* **RelatedPerson**
  * id: us-core-client-tests-related-person

During execution, Inferno will wait for the client under test to issue requests and will
respond to them with the requested data. Inferno will then evaluate the requests in aggregate
to verify that they demonstrate that the client:

* Retrieved instances of each profile
* Performed searches using the required search parameters and search parameter combinations

# Running the Tests

## Quick Start

Inferno's simulated US Core endpoints require authentication using the OAuth flows
conforming to one of the following:
- SMART [App Launch flow](https://hl7.org/fhir/smart-app-launch/STU2.2/app-launch.html), or
- UDAP [Consumer-Facing flow](https://hl7.org/fhir/us/udap-security/STU1/consumer.html).

When creating a test session, select the Client Security Type corresponding to an
authentication approach supported by the client. Then, start by running the "Client Registration"
group which will guide you through the registration process, including what inputs to provide.
See the *Auth Configuration Details* section below for details.

Once registration is complete, run the "Read & Search" group to have Inferno wait for US Core
read and search requests from the client, return the requested CARIN
resources to the client, and verify the interactions. The Patient that the client
needs to request data for has the following demographic details:
- **Resource ID**: us-core-client-tests-patient
- **Name**: ClientTests USCore
- **Member Identifier**: us-core-client-tests-patient (system: Inferno)
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

When running these tests there are 4 options for authentication, which also allows 
Inferno to identify which session the requests are for. The choice is made when the
session is created with the selected Client Security Type option, which determines
what details the tester needs to provide during the Client Registration tests:

- **SMART App Launch Client**: the system under test will manually register
  with Inferno and request access tokens to use when accessing FHIR endpoints
  as per the SMART App Luanch specification, which includes providing one or more
  redirect URI(s) in the **SMART App Launch Redirect URI(s)** input, and optionally,
  launch URL(s) in the **SMART App Launch URL(s)** input. Additionally, testers may provide
  a **Client Id** if they want their client assigned a specific one. Depending on the
  specific SMART flavor chosen, additional inputs for authentication may be needed:
  - **SMART App Launch Public Client**: no additional authentication inputs
  - **SMART App Launch Confidential Symmetric Client**: provide a secret using the
    **SMART Confidential Symmetric Client Secret** input.
  - **SMART App Launch Confidential Asymmetric Client**: provide a URL that resolves
    to a JWKS or a raw JWKS in JSON format using the **SMART JSON Web Key Set (JWKS)** input.
- **UDAP Authorization Code Client**: the system under test will dynamically register
  with Inferno and request access tokens used to access FHIR endpoints
  as per the UDAP specification. It requires the **UDAP Client URI** input
  to be populated with the URI that the client will use when dynamically
  registering with Inferno. This will be used to generate a client id (each
  unique UDAP Client URI will always get the same client id). All other details
  that Inferno needs will be provided as a part of the dynamic registration.

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
- Other must support requirements not outlined above.
- Clients that cannot follow the SMART App Launch or UDAP Consumer-Facing OAuth flows to obtain an access token.


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

        route(:get, METADATA_PATH, USCoreTestKit::Client::MetadataHelper.get_metadata('v501'))
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

        group from: :us_core_client_v501_registration

        group do
          title 'Read & Search'

          run_as_group

          group from: :us_core_client_wait_group_v501

          group from: :us_core_client_v501_auth_smart_alca,
              required_suite_options: {
                client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
              }
          group from: :us_core_client_v501_auth_smart_alcs,
                required_suite_options: {
                  client_type: USCoreClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
                }
          group from: :us_core_client_v501_auth_smart_alp,
                required_suite_options: {
                  client_type: USCoreClientOptions::SMART_APP_LAUNCH_PUBLIC
                }
          group from: :us_core_client_v501_auth_udap,
                required_suite_options: {
                  client_type: USCoreClientOptions::UDAP_AUTHORIZATION_CODE
                }

          group from: :us_core_client_v501_patient
          group from: :us_core_client_v501_allergy_intolerance
          group from: :us_core_client_v501_care_plan
          group from: :us_core_client_v501_care_team
          group from: :us_core_client_v501_condition_encounter_diagnosis
          group from: :us_core_client_v501_condition_problems_health_concerns
          group from: :us_core_client_v501_device
          group from: :us_core_client_v501_diagnostic_report_note
          group from: :us_core_client_v501_diagnostic_report_lab
          group from: :us_core_client_v501_document_reference
          group from: :us_core_client_v501_encounter
          group from: :us_core_client_v501_goal
          group from: :us_core_client_v501_immunization
          group from: :us_core_client_v501_medication_request
          group from: :us_core_client_v501_observation_lab
          group from: :us_core_client_v501_observation_sdoh_assessment
          group from: :us_core_client_v501_respiratory_rate
          group from: :us_core_client_v501_observation_social_history
          group from: :us_core_client_v501_heart_rate
          group from: :us_core_client_v501_body_temperature
          group from: :us_core_client_v501_pediatric_weight_for_height
          group from: :us_core_client_v501_pulse_oximetry
          group from: :us_core_client_v501_smokingstatus
          group from: :us_core_client_v501_observation_sexual_orientation
          group from: :us_core_client_v501_head_circumference
          group from: :us_core_client_v501_body_height
          group from: :us_core_client_v501_bmi
          group from: :us_core_client_v501_blood_pressure
          group from: :us_core_client_v501_observation_imaging
          group from: :us_core_client_v501_observation_clinical_test
          group from: :us_core_client_v501_pediatric_bmi_for_age
          group from: :us_core_client_v501_head_circumference_percentile
          group from: :us_core_client_v501_body_weight
          group from: :us_core_client_v501_procedure
          group from: :us_core_client_v501_questionnaire_response
          group from: :us_core_client_v501_service_request
          group from: :us_core_client_v501_organization
          group from: :us_core_client_v501_practitioner
          group from: :us_core_client_v501_practitioner_role
          group from: :us_core_client_v501_provenance
          group from: :us_core_client_v501_related_person
        end
      end
    end
  end
end
