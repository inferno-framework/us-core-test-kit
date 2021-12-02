require_relative 'bodytemp/bodytemp_patient_code_search_test'
require_relative 'bodytemp/bodytemp_patient_category_date_search_test'
require_relative 'bodytemp/bodytemp_patient_category_status_search_test'
require_relative 'bodytemp/bodytemp_patient_code_date_search_test'
require_relative 'bodytemp/bodytemp_patient_category_search_test'
require_relative 'bodytemp/bodytemp_read_test'
require_relative 'bodytemp/bodytemp_provenance_revinclude_search_test'
require_relative 'bodytemp/bodytemp_validation_test'
require_relative 'bodytemp/bodytemp_must_support_test'
require_relative 'bodytemp/bodytemp_reference_resolution_test'

module USCore
  class BodytempGroup < Inferno::TestGroup
    title 'Bodytemp Tests'
    # description ''

    id :bodytemp

    test from: :bodytemp_patient_code_search_test
    test from: :bodytemp_patient_category_date_search_test
    test from: :bodytemp_patient_category_status_search_test
    test from: :bodytemp_patient_code_date_search_test
    test from: :bodytemp_patient_category_search_test
    test from: :bodytemp_read_test
    test from: :bodytemp_provenance_revinclude_search_test
    test from: :bodytemp_validation_test
    test from: :bodytemp_must_support_test
    test from: :bodytemp_reference_resolution_test
  end
end
