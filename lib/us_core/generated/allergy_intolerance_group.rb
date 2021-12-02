require_relative 'allergy_intolerance/allergy_intolerance_patient_search_test'
require_relative 'allergy_intolerance/allergy_intolerance_patient_clinical_status_search_test'
require_relative 'allergy_intolerance/allergy_intolerance_read_test'
require_relative 'allergy_intolerance/allergy_intolerance_provenance_revinclude_search_test'
require_relative 'allergy_intolerance/allergy_intolerance_validation_test'
require_relative 'allergy_intolerance/allergy_intolerance_must_support_test'

module USCore
  class AllergyIntoleranceGroup < Inferno::TestGroup
    title 'AllergyIntolerance Tests'
    # description ''

    id :allergy_intolerance

    test from: :allergy_intolerance_patient_search_test
    test from: :allergy_intolerance_patient_clinical_status_search_test
    test from: :allergy_intolerance_read_test
    test from: :allergy_intolerance_provenance_revinclude_search_test
    test from: :allergy_intolerance_validation_test
    test from: :allergy_intolerance_must_support_test
  end
end
