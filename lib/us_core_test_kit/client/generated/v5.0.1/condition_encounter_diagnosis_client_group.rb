# frozen_string_literal: true

require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_client_read_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV501
      class ConditionEncounterDiagnosisClientGroup < Inferno::TestGroup
        id :us_core_client_v501_condition_encounter_diagnosis

        title 'Condition Encounter Diagnosis'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Condition queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-condition-encounter-diagnosis`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient

        )

        run_as_group

        test from: :us_core_v501_condition_encounter_diagnosis_client_read_test
        test from: :us_core_v501_condition_encounter_diagnosis_patient_client_search_test
      end
    end
  end
end
