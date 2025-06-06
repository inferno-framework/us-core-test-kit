# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class ConditionEncounterDiagnosisClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v501_condition_encounter_diagnosis_client_read_test
        title 'SHALL support read of ConditionEncounterDiagnosis'
        description %(
          The client demonstrates SHALL support for reading ConditionEncounterDiagnosis.
        )

        input :condition_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Condition` resource type, so support for US Core Condition Encounter Diagnosis Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Condition Encounter Diagnosis Profile: `Condition/us-core-client-tests-condition-encounter-diagnosis`."
        end

        run do
          if parent_optional?
            omit_if condition_support.blank?, skip_message
          else
            skip_if condition_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_CONDITION_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-condition-encounter-diagnosis')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
