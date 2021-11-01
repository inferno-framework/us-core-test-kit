require_relative 'heartrate/heartrate_patient_code_search_test'
require_relative 'heartrate/heartrate_status_search_test'
require_relative 'heartrate/heartrate_category_search_test'
require_relative 'heartrate/heartrate_code_search_test'
require_relative 'heartrate/heartrate_date_search_test'
require_relative 'heartrate/heartrate_patient_search_test'
require_relative 'heartrate/heartrate_patient_category_date_search_test'
require_relative 'heartrate/heartrate_patient_category_status_search_test'
require_relative 'heartrate/heartrate_patient_code_date_search_test'
require_relative 'heartrate/heartrate_patient_category_search_test'
require_relative 'heartrate/heartrate_read_test'

module USCore
  class HeartrateGroup < Inferno::TestGroup
    title 'Heartrate Tests'
    # description ''

    id :heartrate

    test from: :heartrate_patient_code_search_test
    test from: :heartrate_status_search_test
    test from: :heartrate_category_search_test
    test from: :heartrate_code_search_test
    test from: :heartrate_date_search_test
    test from: :heartrate_patient_search_test
    test from: :heartrate_patient_category_date_search_test
    test from: :heartrate_patient_category_status_search_test
    test from: :heartrate_patient_code_date_search_test
    test from: :heartrate_patient_category_search_test
    test from: :heartrate_read_test
  end
end
