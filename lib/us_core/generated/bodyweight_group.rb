require_relative 'bodyweight/bodyweight_patient_code_search_test'
require_relative 'bodyweight/bodyweight_patient_category_date_search_test'
require_relative 'bodyweight/bodyweight_patient_category_status_search_test'
require_relative 'bodyweight/bodyweight_patient_code_date_search_test'
require_relative 'bodyweight/bodyweight_patient_category_search_test'
require_relative 'bodyweight/bodyweight_read_test'
require_relative 'bodyweight/bodyweight_provenance_revinclude_search_test'
require_relative 'bodyweight/bodyweight_validation_test'
require_relative 'bodyweight/bodyweight_must_support_test'
require_relative 'bodyweight/bodyweight_reference_resolution_test'

module USCore
  class BodyweightGroup < Inferno::TestGroup
    title 'Bodyweight Tests'
    # description ''

    id :bodyweight

    test from: :bodyweight_patient_code_search_test
    test from: :bodyweight_patient_category_date_search_test
    test from: :bodyweight_patient_category_status_search_test
    test from: :bodyweight_patient_code_date_search_test
    test from: :bodyweight_patient_category_search_test
    test from: :bodyweight_read_test
    test from: :bodyweight_provenance_revinclude_search_test
    test from: :bodyweight_validation_test
    test from: :bodyweight_must_support_test
    test from: :bodyweight_reference_resolution_test
  end
end
