require_relative './condition_granular_scope2_group'
require_relative './diagnostic_report_granular_scope2_group'
require_relative './observation_granular_scope2_group'
require_relative './service_request_granular_scope2_group'

module USCoreTestKit
  module USCoreV700_BALLOT
    class SmartGranularScopes2Group < Inferno::TestGroup
      id :us_core_v700_ballot_smart_granular_scopes_2
      title 'US Core FHIR API w/Granular Scopes 2'

      description %(
The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item`
* `DiagnosticReport.rs?category=http://loinc.org|LP7839-6`
* `DiagnosticReport.rs?category=http://terminology.hl7.org/CodeSystem/v2-0074|LAB`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|vital-signs`
* `Observation.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|treatment-intervention-preference`
* `Observation.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|care-experience-preference`
* `patient.Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|survey`
* `ServiceRequest.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|functional-status`
* `ServiceRequest.rs?category=http://snomed.info/sct|387713003`

      )

      input :granular_scopes_2_credentials,
            title: 'SMART Credentials for Granular Scopes 2',
            type: :oauth_credentials,
            locked: true

      config(
        inputs: {
          patient_ids: {
            locked: true
          },
          received_scopes: {
            title: 'Received Scopes',
            locked: true
          },
          url: {
            locked: true
          }
        }
      )

      fhir_client do
        oauth_credentials :granular_scopes_2_credentials
        url :url
      end

      group from: :us_core_v700_ballot_condition_granular_scope_2_group
      group from: :us_core_v700_ballot_diagnostic_report_granular_scope_2_group
      group from: :us_core_v700_ballot_observation_granular_scope_2_group
      group from: :us_core_v700_ballot_service_request_granular_scope_2_group
    end
  end
end
