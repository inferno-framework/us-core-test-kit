require_relative './condition_granular_scope1_group'
require_relative './observation_granular_scope1_group'

module USCoreTestKit
  module USCoreV610
    class SmartGranularScopes1Group < Inferno::TestGroup
      id :us_core_v610_smart_granular_scopes_1
      title 'US Core FHIR API w/Granular Scopes 1'

      description %(
The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis`
* `Condition.rs?category=http://hl7.org/fhir/us/core/CodeSystem/condition-category|health-concern`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|social-history`

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

      group from: :us_core_v610_condition_granular_scope_1_group
      group from: :us_core_v610_observation_granular_scope_1_group
    end
  end
end
