require_relative 'allergy_intolerance/allergy_intolerance_patient_search_test'
require_relative 'allergy_intolerance/allergy_intolerance_clinical_status_search_test'
require_relative 'allergy_intolerance/allergy_intolerance_patient_clinical_status_search_test'
require_relative 'allergy_intolerance/allergy_intolerance_read_test'

module USCore
  class AllergyIntoleranceGroup < Inferno::TestGroup
    title 'AllergyIntolerance Tests'
    # description ''

    id :allergy_intolerance

    test from: :allergy_intolerance_patient_search_test
    test from: :allergy_intolerance_clinical_status_search_test
    test from: :allergy_intolerance_patient_clinical_status_search_test
    test from: :allergy_intolerance_read_test
  end
end
