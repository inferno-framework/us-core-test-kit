require_relative 'condition/condition_patient_search_test'
require_relative 'condition/condition_category_search_test'
require_relative 'condition/condition_clinical_status_search_test'
require_relative 'condition/condition_onset_date_search_test'
require_relative 'condition/condition_code_search_test'
require_relative 'condition/condition_patient_onset_date_search_test'
require_relative 'condition/condition_patient_category_search_test'
require_relative 'condition/condition_patient_clinical_status_search_test'
require_relative 'condition/condition_patient_code_search_test'
require_relative 'condition/condition_read_test'
require_relative 'condition/condition_provenance_revinclude_search_test'
require_relative 'condition/condition_validation_test'

module USCore
  class ConditionGroup < Inferno::TestGroup
    title 'Condition Tests'
    # description ''

    id :condition

    test from: :condition_patient_search_test
    test from: :condition_category_search_test
    test from: :condition_clinical_status_search_test
    test from: :condition_onset_date_search_test
    test from: :condition_code_search_test
    test from: :condition_patient_onset_date_search_test
    test from: :condition_patient_category_search_test
    test from: :condition_patient_clinical_status_search_test
    test from: :condition_patient_code_search_test
    test from: :condition_read_test
    test from: :condition_provenance_revinclude_search_test
    test from: :condition_validation_test
  end
end
