require_relative 'bodytemp/bodytemp_patient_code_search_test'
require_relative 'bodytemp/bodytemp_status_search_test'
require_relative 'bodytemp/bodytemp_category_search_test'
require_relative 'bodytemp/bodytemp_code_search_test'
require_relative 'bodytemp/bodytemp_date_search_test'
require_relative 'bodytemp/bodytemp_patient_search_test'
require_relative 'bodytemp/bodytemp_patient_category_date_search_test'
require_relative 'bodytemp/bodytemp_patient_category_status_search_test'
require_relative 'bodytemp/bodytemp_patient_code_date_search_test'
require_relative 'bodytemp/bodytemp_patient_category_search_test'
require_relative 'bodytemp/bodytemp_read_test'
require_relative 'bodytemp/bodytemp_provenance_revinclude_search_test'
require_relative 'bodytemp/bodytemp_validation_test'

module USCore
  class BodytempGroup < Inferno::TestGroup
    title 'Bodytemp Tests'
    # description ''

    id :bodytemp

    test from: :bodytemp_patient_code_search_test
    test from: :bodytemp_status_search_test
    test from: :bodytemp_category_search_test
    test from: :bodytemp_code_search_test
    test from: :bodytemp_date_search_test
    test from: :bodytemp_patient_search_test
    test from: :bodytemp_patient_category_date_search_test
    test from: :bodytemp_patient_category_status_search_test
    test from: :bodytemp_patient_code_date_search_test
    test from: :bodytemp_patient_category_search_test
    test from: :bodytemp_read_test
    test from: :bodytemp_provenance_revinclude_search_test
    test from: :bodytemp_validation_test
  end
end
