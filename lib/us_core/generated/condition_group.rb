require_relative 'condition/condition_patient_search_test'
require_relative 'condition/condition_patient_onset_date_search_test'
require_relative 'condition/condition_patient_category_search_test'
require_relative 'condition/condition_patient_clinical_status_search_test'
require_relative 'condition/condition_patient_code_search_test'
require_relative 'condition/condition_read_test'
require_relative 'condition/condition_provenance_revinclude_search_test'
require_relative 'condition/condition_validation_test'
require_relative 'condition/condition_must_support_test'
require_relative 'condition/condition_reference_resolution_test'

module USCore
  class ConditionGroup < Inferno::TestGroup
    title 'Condition Tests'
    # description ''

    id :condition

    test from: :condition_patient_search_test
    test from: :condition_patient_onset_date_search_test
    test from: :condition_patient_category_search_test
    test from: :condition_patient_clinical_status_search_test
    test from: :condition_patient_code_search_test
    test from: :condition_read_test
    test from: :condition_provenance_revinclude_search_test
    test from: :condition_validation_test
    test from: :condition_must_support_test
    test from: :condition_reference_resolution_test
  end
end
