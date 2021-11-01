require_relative 'resprate/resprate_patient_code_search_test'
require_relative 'resprate/resprate_status_search_test'
require_relative 'resprate/resprate_category_search_test'
require_relative 'resprate/resprate_code_search_test'
require_relative 'resprate/resprate_date_search_test'
require_relative 'resprate/resprate_patient_search_test'
require_relative 'resprate/resprate_patient_category_date_search_test'
require_relative 'resprate/resprate_patient_category_status_search_test'
require_relative 'resprate/resprate_patient_code_date_search_test'
require_relative 'resprate/resprate_patient_category_search_test'
require_relative 'resprate/resprate_read_test'

module USCore
  class ResprateGroup < Inferno::TestGroup
    title 'Resprate Tests'
    # description ''

    id :resprate

    test from: :resprate_patient_code_search_test
    test from: :resprate_status_search_test
    test from: :resprate_category_search_test
    test from: :resprate_code_search_test
    test from: :resprate_date_search_test
    test from: :resprate_patient_search_test
    test from: :resprate_patient_category_date_search_test
    test from: :resprate_patient_category_status_search_test
    test from: :resprate_patient_code_date_search_test
    test from: :resprate_patient_category_search_test
    test from: :resprate_read_test
  end
end
