require_relative './condition_granular_scope1_group'
require_relative './diagnostic_report_granular_scope1_group'
require_relative './document_reference_granular_scope1_group'
require_relative './observation_granular_scope1_group'
require_relative './service_request_granular_scope1_group'

module USCoreTestKit
  module USCoreV700_BALLOT
    class SmartGranularScopes1Group < Inferno::TestGroup
      id :us_core_v700_ballot_smart_granular_scopes_1
      title 'US Core FHIR API w/Granular Scopes 1'

      description %(
The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis`
* `Condition.rs?category=http://hl7.org/fhir/us/core/CodeSystem/condition-category|health-concern`
* `DiagnosticReport.rs?category=http://loinc.org|LP29684-5`
* `DiagnosticReport.rs?category=http://loinc.org|LP29708-2`
* `DocumentReference.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category|clinical-note`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|social-history`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|imaging`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|procedure`
* `ServiceRequest.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|sdoh`

      )

      input :granular_scopes_1_credentials,
            title: 'SMART Credentials for Granular Scopes 1',
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
        oauth_credentials :granular_scopes_1_credentials
        url :url
      end

      group from: :us_core_v700_ballot_condition_granular_scope_1_group
      group from: :us_core_v700_ballot_diagnostic_report_granular_scope_1_group
      group from: :us_core_v700_ballot_document_reference_granular_scope_1_group
      group from: :us_core_v700_ballot_observation_granular_scope_1_group
      group from: :us_core_v700_ballot_service_request_granular_scope_1_group
    end
  end
end
