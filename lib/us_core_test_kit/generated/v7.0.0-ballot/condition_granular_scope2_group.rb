require_relative './granular_scope_tests/condition/condition_patient_category_granular_scope_test'
require_relative './granular_scope_tests/condition/condition_patient_granular_scope_test'
require_relative './granular_scope_tests/condition/condition_patient_asserted_date_granular_scope_test'
require_relative './granular_scope_tests/condition/condition_patient_onset_date_granular_scope_test'
require_relative './granular_scope_tests/condition/condition_patient_code_granular_scope_test'
require_relative './granular_scope_tests/condition/condition_patient_recorded_date_granular_scope_test'
require_relative './granular_scope_tests/condition/condition_patient_abatement_date_granular_scope_test'
require_relative './granular_scope_tests/condition/condition_patient_category_clinical_status_granular_scope_test'
require_relative './granular_scope_tests/condition/condition_patient_category_encounter_granular_scope_test'
require_relative './granular_scope_tests/condition/condition_patient_clinical_status_granular_scope_test'
require_relative './granular_scope_tests/condition/condition_read_granular_scope_test'

module USCoreTestKit
  module USCoreV700_BALLOT
    class ConditionGranularScope2Group < Inferno::TestGroup
      title 'Condition Granular Scope Tests Tests'
      short_description 'Verify support for the server capabilities required by the US Core Condition Encounter Diagnosis Profile.'
      description %(
  The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `Condition.rs?category=http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item`

      )

      id :us_core_v700_ballot_condition_granular_scope_2_group
      run_as_group

    
      test from: :us_core_v700_ballot_Condition_patient_category_granular_scope_test
      test from: :us_core_v700_ballot_Condition_patient_granular_scope_test
      test from: :us_core_v700_ballot_Condition_patient_asserted_date_granular_scope_test
      test from: :us_core_v700_ballot_Condition_patient_onset_date_granular_scope_test
      test from: :us_core_v700_ballot_Condition_patient_code_granular_scope_test
      test from: :us_core_v700_ballot_Condition_patient_recorded_date_granular_scope_test
      test from: :us_core_v700_ballot_Condition_patient_abatement_date_granular_scope_test
      test from: :us_core_v700_ballot_Condition_patient_category_clinical_status_granular_scope_test
      test from: :us_core_v700_ballot_Condition_patient_category_encounter_granular_scope_test
      test from: :us_core_v700_ballot_Condition_patient_clinical_status_granular_scope_test
      test from: :us_core_v700_ballot_Condition_read_granular_scope_test
    end
  end
end
