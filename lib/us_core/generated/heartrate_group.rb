require_relative 'heartrate/heartrate_patient_code_search_test'
require_relative 'heartrate/heartrate_patient_category_date_search_test'
require_relative 'heartrate/heartrate_patient_category_status_search_test'
require_relative 'heartrate/heartrate_patient_code_date_search_test'
require_relative 'heartrate/heartrate_patient_category_search_test'
require_relative 'heartrate/heartrate_read_test'
require_relative 'heartrate/heartrate_provenance_revinclude_search_test'
require_relative 'heartrate/heartrate_validation_test'
require_relative 'heartrate/heartrate_must_support_test'
require_relative 'heartrate/heartrate_reference_resolution_test'

module USCore
  class HeartrateGroup < Inferno::TestGroup
    title 'Heartrate Tests'
    # description ''

    id :heartrate

    test from: :heartrate_patient_code_search_test
    test from: :heartrate_patient_category_date_search_test
    test from: :heartrate_patient_category_status_search_test
    test from: :heartrate_patient_code_date_search_test
    test from: :heartrate_patient_category_search_test
    test from: :heartrate_read_test
    test from: :heartrate_provenance_revinclude_search_test
    test from: :heartrate_validation_test
    test from: :heartrate_must_support_test
    test from: :heartrate_reference_resolution_test
  end
end
