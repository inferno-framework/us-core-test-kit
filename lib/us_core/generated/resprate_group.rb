require_relative 'resprate/resprate_patient_code_search_test'
require_relative 'resprate/resprate_patient_category_date_search_test'
require_relative 'resprate/resprate_patient_category_status_search_test'
require_relative 'resprate/resprate_patient_code_date_search_test'
require_relative 'resprate/resprate_patient_category_search_test'
require_relative 'resprate/resprate_read_test'
require_relative 'resprate/resprate_provenance_revinclude_search_test'
require_relative 'resprate/resprate_validation_test'
require_relative 'resprate/resprate_must_support_test'

module USCore
  class ResprateGroup < Inferno::TestGroup
    title 'Resprate Tests'
    # description ''

    id :resprate

    test from: :resprate_patient_code_search_test
    test from: :resprate_patient_category_date_search_test
    test from: :resprate_patient_category_status_search_test
    test from: :resprate_patient_code_date_search_test
    test from: :resprate_patient_category_search_test
    test from: :resprate_read_test
    test from: :resprate_provenance_revinclude_search_test
    test from: :resprate_validation_test
    test from: :resprate_must_support_test
  end
end
