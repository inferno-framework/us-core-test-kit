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

        def skip_message
          "Inferno did not receive any read requests for the `Condition` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Condition Encounter Diagnosis Profile: `Condition/us-core-client-tests-condition-encounter-diagnosis`."
        end

        run do
          requests = load_tagged_requests(READ_CONDITION_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-condition-encounter-diagnosis')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
