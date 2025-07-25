# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class ConditionEncounterDiagnosisClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v501_condition_encounter_diagnosis_client_support_test
        title 'Support Condition Resource Access'
        description %(
          
            This test checks whether the client made requests for the Condition FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-condition-encounter-diagnosis` for the US Core Condition Encounter Diagnosis Profile.
          
        )

        output :condition_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Condition`."
        end

        run do
          condition_read_requests = load_tagged_requests(READ_CONDITION_TAG)
          condition_search_requests = load_tagged_requests(SEARCH_CONDITION_TAG)
          condition_support = 
            condition_read_requests.length > 0 ||
            condition_search_requests.length > 0
          if parent_optional?
            omit_if !condition_support, skip_message
          else
            skip_if !condition_support, skip_message
          end

          (output condition_support:)
        end
      end
    end
  end
end
