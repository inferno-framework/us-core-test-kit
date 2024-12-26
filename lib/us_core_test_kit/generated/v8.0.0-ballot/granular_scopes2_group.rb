require_relative './condition_granular_scope2_group'
require_relative './observation_granular_scope2_group'

module USCoreTestKit
  module USCoreV800_BALLOT
    class SmartGranularScopes2Group < Inferno::TestGroup
      id :us_core_v800_ballot_smart_granular_scopes_2
      title 'US Core FHIR API w/Granular Scopes 2'

      description %(
The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|vital-signs`
* `Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|survey`
* `Observation.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|sdoh`

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

      group from: :us_core_v800_ballot_condition_granular_scope_2_group
      group from: :us_core_v800_ballot_observation_granular_scope_2_group
    end
  end
end
