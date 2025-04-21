# frozen_string_literal: true

require_relative '../../../version'
require_relative 'tags'
require_relative 'urls'
require_relative 'read_endpoint'
require_relative 'search_endpoint'
require_relative '../../test_helper'
require_relative 'wait_group'
require_relative 'patient_client_group'
require_relative 'allergy_intolerance_client_group'
require_relative 'care_plan_client_group'
require_relative 'care_team_client_group'
require_relative 'condition_client_group'
require_relative 'device_client_group'
require_relative 'diagnostic_report_lab_client_group'
require_relative 'diagnostic_report_note_client_group'
require_relative 'document_reference_client_group'
require_relative 'goal_client_group'
require_relative 'immunization_client_group'
require_relative 'medication_request_client_group'
require_relative 'observation_lab_client_group'
require_relative 'blood_pressure_client_group'
require_relative 'bmi_client_group'
require_relative 'head_circumference_client_group'
require_relative 'body_height_client_group'
require_relative 'body_weight_client_group'
require_relative 'body_temperature_client_group'
require_relative 'heart_rate_client_group'
require_relative 'pediatric_bmi_for_age_client_group'
require_relative 'head_circumference_percentile_client_group'
require_relative 'pediatric_weight_for_height_client_group'
require_relative 'pulse_oximetry_client_group'
require_relative 'respiratory_rate_client_group'
require_relative 'smokingstatus_client_group'
require_relative 'procedure_client_group'
require_relative 'encounter_client_group'
require_relative 'organization_client_group'
require_relative 'practitioner_client_group'
require_relative 'provenance_client_group'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class USCoreClientTestSuite < Inferno::TestSuite
        include URLs

        id :us_core_client_v400

        title 'US Core Client v4.0.0'

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
* **DiagnosticReportLab**
  * id: us-core-client-tests-diagnostic-report-lab
* **DiagnosticReportNote**
  * id: us-core-client-tests-diagnostic-report-note
* **DocumentReference**
  * id: us-core-client-tests-document-reference
* **Goal**
  * id: us-core-client-tests-goal
* **Immunization**
  * id: us-core-client-tests-immunization
* **MedicationRequest**
  * id: us-core-client-tests-medication-request
* **ObservationLab**
  * id: us-core-client-tests-observation-lab
* **BloodPressure**
  * id: us-core-client-tests-blood-pressure
* **Bmi**
  * id: us-core-client-tests-bmi
* **HeadCircumference**
  * id: us-core-client-tests-head-circumference
* **BodyHeight**
  * id: us-core-client-tests-body-height
* **BodyWeight**
  * id: us-core-client-tests-body-weight
* **BodyTemperature**
  * id: us-core-client-tests-body-temperature
* **HeartRate**
  * id: us-core-client-tests-heart-rate
* **PediatricBmiForAge**
  * id: us-core-client-tests-pediatric-bmi-for-age
* **HeadCircumferencePercentile**
  * id: us-core-client-tests-head-circumference-percentile
* **PediatricWeightForHeight**
  * id: us-core-client-tests-pediatric-weight-for-height
* **PulseOximetry**
  * id: us-core-client-tests-pulse-oximetry
* **RespiratoryRate**
  * id: us-core-client-tests-respiratory-rate
* **Smokingstatus**
  * id: us-core-client-tests-smokingstatus
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
This script will simulate a client by making requests to Inferno.

# Current Limitations

This test suite is still in draft form and does not test all of the client requirements and features
described in the US Core Implementation guide.

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

        suite_endpoint :get, READ_ROUTE, ReadEndpoint
        suite_endpoint :get, SEARCH_ROUTE, SearchEndpoint

        resume_test_route :get, RESUME_PASS_ROUTE do |request|
          request.query_parameters['id']
        end

        group do
          title 'Read & Search'

          run_as_group

          group from: :us_core_client_wait_group_v400

          group from: :us_core_client_v400_patient
          group from: :us_core_client_v400_allergy_intolerance
          group from: :us_core_client_v400_care_plan
          group from: :us_core_client_v400_care_team
          group from: :us_core_client_v400_condition
          group from: :us_core_client_v400_device
          group from: :us_core_client_v400_diagnostic_report_lab
          group from: :us_core_client_v400_diagnostic_report_note
          group from: :us_core_client_v400_document_reference
          group from: :us_core_client_v400_goal
          group from: :us_core_client_v400_immunization
          group from: :us_core_client_v400_medication_request
          group from: :us_core_client_v400_observation_lab
          group from: :us_core_client_v400_blood_pressure
          group from: :us_core_client_v400_bmi
          group from: :us_core_client_v400_head_circumference
          group from: :us_core_client_v400_body_height
          group from: :us_core_client_v400_body_weight
          group from: :us_core_client_v400_body_temperature
          group from: :us_core_client_v400_heart_rate
          group from: :us_core_client_v400_pediatric_bmi_for_age
          group from: :us_core_client_v400_head_circumference_percentile
          group from: :us_core_client_v400_pediatric_weight_for_height
          group from: :us_core_client_v400_pulse_oximetry
          group from: :us_core_client_v400_respiratory_rate
          group from: :us_core_client_v400_smokingstatus
          group from: :us_core_client_v400_procedure
          group from: :us_core_client_v400_encounter
          group from: :us_core_client_v400_organization
          group from: :us_core_client_v400_practitioner
          group from: :us_core_client_v400_provenance
        end
      end
    end
  end
end
