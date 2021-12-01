require_relative 'bodyweight/bodyweight_patient_code_search_test'
require_relative 'bodyweight/bodyweight_status_search_test'
require_relative 'bodyweight/bodyweight_category_search_test'
require_relative 'bodyweight/bodyweight_code_search_test'
require_relative 'bodyweight/bodyweight_date_search_test'
require_relative 'bodyweight/bodyweight_patient_search_test'
require_relative 'bodyweight/bodyweight_patient_category_date_search_test'
require_relative 'bodyweight/bodyweight_patient_category_status_search_test'
require_relative 'bodyweight/bodyweight_patient_code_date_search_test'
require_relative 'bodyweight/bodyweight_patient_category_search_test'
require_relative 'bodyweight/bodyweight_read_test'
require_relative 'bodyweight/bodyweight_validation_test'

module USCore
  class BodyweightGroup < Inferno::TestGroup
    title 'Bodyweight Tests'
    # description ''

    id :bodyweight

    test from: :bodyweight_patient_code_search_test
    test from: :bodyweight_status_search_test
    test from: :bodyweight_category_search_test
    test from: :bodyweight_code_search_test
    test from: :bodyweight_date_search_test
    test from: :bodyweight_patient_search_test
    test from: :bodyweight_patient_category_date_search_test
    test from: :bodyweight_patient_category_status_search_test
    test from: :bodyweight_patient_code_date_search_test
    test from: :bodyweight_patient_category_search_test
    test from: :bodyweight_read_test
    test from: :bodyweight_validation_test
  end
end
