require_relative 'bp/bp_patient_code_search_test'
require_relative 'bp/bp_status_search_test'
require_relative 'bp/bp_category_search_test'
require_relative 'bp/bp_code_search_test'
require_relative 'bp/bp_date_search_test'
require_relative 'bp/bp_patient_search_test'
require_relative 'bp/bp_patient_category_date_search_test'
require_relative 'bp/bp_patient_category_status_search_test'
require_relative 'bp/bp_patient_code_date_search_test'
require_relative 'bp/bp_patient_category_search_test'
require_relative 'bp/bp_read_test'

module USCore
  class BpGroup < Inferno::TestGroup
    title 'Bp Tests'
    # description ''

    id :bp

    test from: :bp_patient_code_search_test
    test from: :bp_status_search_test
    test from: :bp_category_search_test
    test from: :bp_code_search_test
    test from: :bp_date_search_test
    test from: :bp_patient_search_test
    test from: :bp_patient_category_date_search_test
    test from: :bp_patient_category_status_search_test
    test from: :bp_patient_code_date_search_test
    test from: :bp_patient_category_search_test
    test from: :bp_read_test
  end
end
