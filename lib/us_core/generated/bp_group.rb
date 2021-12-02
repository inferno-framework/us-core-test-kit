require_relative 'bp/bp_patient_code_search_test'
require_relative 'bp/bp_patient_category_date_search_test'
require_relative 'bp/bp_patient_category_status_search_test'
require_relative 'bp/bp_patient_code_date_search_test'
require_relative 'bp/bp_patient_category_search_test'
require_relative 'bp/bp_read_test'
require_relative 'bp/bp_provenance_revinclude_search_test'
require_relative 'bp/bp_validation_test'
require_relative 'bp/bp_must_support_test'
require_relative 'bp/bp_reference_resolution_test'

module USCore
  class BpGroup < Inferno::TestGroup
    title 'Bp Tests'
    # description ''

    id :bp

    test from: :bp_patient_code_search_test
    test from: :bp_patient_category_date_search_test
    test from: :bp_patient_category_status_search_test
    test from: :bp_patient_code_date_search_test
    test from: :bp_patient_category_search_test
    test from: :bp_read_test
    test from: :bp_provenance_revinclude_search_test
    test from: :bp_validation_test
    test from: :bp_must_support_test
    test from: :bp_reference_resolution_test
  end
end
