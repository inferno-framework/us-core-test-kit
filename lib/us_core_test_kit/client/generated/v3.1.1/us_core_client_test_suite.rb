# frozen_string_literal: true

require 'smart_app_launch_test_kit'
require_relative '../../../version'
require_relative 'tags'
require_relative 'urls'
require_relative '../../metadata_helper'
require_relative 'read_endpoint'
require_relative 'search_endpoint'
require_relative '../../test_helper'
require_relative '../../us_core_client_options'
require_relative 'registration_group'
require_relative 'wait_group'
require_relative 'auth_smart_alca_group'
require_relative 'auth_smart_alcs_group'
require_relative 'auth_smart_alp_group'
require_relative 'patient_client_group'
require_relative 'allergy_intolerance_client_group'
require_relative 'care_plan_client_group'
require_relative 'care_team_client_group'
require_relative 'condition_client_group'
require_relative 'device_client_group'
require_relative 'diagnostic_report_note_client_group'
require_relative 'diagnostic_report_lab_client_group'
require_relative 'document_reference_client_group'
require_relative 'encounter_client_group'
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
require_relative 'organization_client_group'
require_relative 'practitioner_client_group'
require_relative 'procedure_client_group'
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
to the [US Core Implementation Guide](http://hl7.org/fhir/us/core/STU3.1.1).

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

* **[US Core Patient Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|3.1.1)** (id: us-core-client-tests-patient)
* **[US Core AllergyIntolerance Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance|3.1.1)** (id: us-core-client-tests-allergy-intolerance)
* **[US Core CarePlan Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan|3.1.1)** (id: us-core-client-tests-care-plan)
* **[US Core CareTeam Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam|3.1.1)** (id: us-core-client-tests-care-team)
* **[US Core Condition Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition|3.1.1)** (id: us-core-client-tests-condition-encounter-diagnosis)
* **[US Core Implantable Device Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device|3.1.1)** (id: us-core-client-tests-device)
* **[US Core DiagnosticReport Profile for Report and Note exchange](http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note|3.1.1)** (id: us-core-client-tests-diagnostic-report-note)
* **[US Core DiagnosticReport Profile for Laboratory Results Reporting](http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab|3.1.1)** (id: us-core-client-tests-diagnostic-report-lab)
* **[US Core DocumentReference Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference|3.1.1)** (id: us-core-client-tests-document-reference)
* **[US Core Encounter Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter|3.1.1)** (id: us-core-client-tests-encounter)
* **[US Core Goal Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal|3.1.1)** (id: us-core-client-tests-goal)
* **[US Core Immunization Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization|3.1.1)** (id: us-core-client-tests-immunization)
* **[US Core MedicationRequest Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest|3.1.1)** (id: us-core-client-tests-medication-request)
* **[US Core Smoking Status Observation Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus|3.1.1)** (id: us-core-client-tests-smokingstatus)
* **[US Core Pediatric Weight for Height Observation Profile](http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height|3.1.1)** (id: us-core-client-tests-pediatric-weight-for-height)
* **[US Core Laboratory Result Observation Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab|3.1.1)** (id: us-core-client-tests-observation-lab)
* **[US Core Pediatric BMI for Age Observation Profile](http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age|3.1.1)** (id: us-core-client-tests-pediatric-bmi-for-age)
* **[US Core Pulse Oximetry Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry|3.1.1)** (id: us-core-client-tests-pulse-oximetry)
* **[US Core Pediatric Head Occipital-frontal Circumference Percentile Profile](http://hl7.org/fhir/us/core/StructureDefinition/head-occipital-frontal-circumference-percentile|3.1.1)** (id: us-core-client-tests-head-circumference-percentile)
* **[Observation Body Height Profile](http://hl7.org/fhir/StructureDefinition/bodyheight|4.0.1)** (id: us-core-client-tests-body-height)
* **[Observation Body Temperature Profile](http://hl7.org/fhir/StructureDefinition/bodytemp|4.0.1)** (id: us-core-client-tests-body-temperature)
* **[Observation Blood Pressure Profile](http://hl7.org/fhir/StructureDefinition/bp|4.0.1)** (id: us-core-client-tests-blood-pressure)
* **[Observation Body Weight Profile](http://hl7.org/fhir/StructureDefinition/bodyweight|4.0.1)** (id: us-core-client-tests-body-weight)
* **[Observation Heart Rate Profile](http://hl7.org/fhir/StructureDefinition/heartrate|4.0.1)** (id: us-core-client-tests-heart-rate)
* **[Observation Respiratory Rate Profile](http://hl7.org/fhir/StructureDefinition/resprate|4.0.1)** (id: us-core-client-tests-respiratory-rate)
* **[US Core Organization Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization|3.1.1)** (id: us-core-client-tests-organization)
* **[US Core Practitioner Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner|3.1.1)** (id: us-core-client-tests-practitioner)
* **[US Core Procedure Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure|3.1.1)** (id: us-core-client-tests-procedure)
* **[US Core Provenance Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance|3.1.1)** (id: us-core-client-tests-provenance)

# Current Limitations

This test suite is still in draft form and does not test all of the client requirements and features
described in the US Core Implementation guide.

The current version of this test suite supports the following tests using a specific Inferno-specified patient:
- Testing a client's ability to perform read requests against a FHIR server for all US Core Profiles
  listed in the [US Core Client CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-client.html).
- Testing a client's ability to perform searches using search parameters and combinations
  listed for each resource type in the [US Core Client CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-client.html).

The current version of this test suite does not:
- Support esting searches with/via:
  - date comparator
  - multiple-OR
  - _revInclude
- Verify that date and dateTime search parameter values are provided at the required level of precision.
- Check the Must Support Conformance Requirements for clients/requestors specified in US Core IG v3.1.1
- Support clients that cannot follow the SMART App Launch OAuth flow to obtain an access token.
- Allow testers to bring their own data. Testers must manually configure their client system to connect
  to a specific target patient and must access and process specific curated sample US Core data.


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
          },
          {
            label: 'Implementation Guide',
            url: 'http://hl7.org/fhir/us/core/STU3.1.1'
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
                        }
                      ]

        route(:get, METADATA_PATH, USCoreTestKit::Client::MetadataHelper.get_metadata('v311'))
        route(:get, SMARTAppLaunch::SMART_DISCOVERY_PATH, lambda { |_env|
          SMARTAppLaunch::MockSMARTServer.smart_server_metadata(id)
        })
        route(:get, SMARTAppLaunch::OIDC_DISCOVERY_PATH, ->(_env) {SMARTAppLaunch::MockSMARTServer.openid_connect_metadata(id) }) 
        route(
          :get,
          SMARTAppLaunch::OIDC_JWKS_PATH,
          ->(_env) { [200, { 'Content-Type' => 'application/json' }, [SMARTAppLaunch::OIDCJWKS.jwks_json]] }
        )

        suite_endpoint :post, SMARTAppLaunch::TOKEN_PATH, SMARTAppLaunch::MockSMARTServer::TokenEndpoint
        suite_endpoint :get,  SMARTAppLaunch::AUTHORIZATION_PATH, SMARTAppLaunch::MockSMARTServer::AuthorizationEndpoint
        suite_endpoint :post, SMARTAppLaunch::AUTHORIZATION_PATH, SMARTAppLaunch::MockSMARTServer::AuthorizationEndpoint

        suite_endpoint :post, SEARCH_POST_ROUTE, SearchEndpoint
        suite_endpoint :get, SEARCH_ROUTE, SearchEndpoint
        suite_endpoint :get, READ_ROUTE, ReadEndpoint

        resume_test_route :get, RESUME_PASS_ROUTE do |request|
          request.query_parameters['token']
        end

        group from: :us_core_client_v311_registration

        group do
          id :us_core_client_read_search_group_v311
          title 'Read & Search'
          description %(
            
During these tests, the US Core client system will interact with Inferno's simulated US Core Server
and demonstrate its ability to perform the FHIR interactions described in the [US Core Client CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-client.html).


          )

          run_as_group

          group from: :us_core_client_wait_group_v311

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

          group from: :us_core_client_v311_patient
          group from: :us_core_client_v311_allergy_intolerance
          group from: :us_core_client_v311_care_plan
          group from: :us_core_client_v311_care_team
          group from: :us_core_client_v311_condition
          group from: :us_core_client_v311_device
          group from: :us_core_client_v311_diagnostic_report_note
          group from: :us_core_client_v311_diagnostic_report_lab
          group from: :us_core_client_v311_document_reference
          group from: :us_core_client_v311_encounter
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
          group from: :us_core_client_v311_organization
          group from: :us_core_client_v311_practitioner
          group from: :us_core_client_v311_procedure
          group from: :us_core_client_v311_provenance

          run do
            passing_profile_group = groups.find do |group|
              next if group.id.include?('wait') || group.id.include?('auth')

              results[group.id]&.result == 'pass'
            end

            assert passing_profile_group.present?, 'At least one profile group must pass.'
          end
        end
      end
    end
  end
end
