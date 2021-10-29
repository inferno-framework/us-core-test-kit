require_relative 'head_circumference/head_circumference_patient_code_search_test'
require_relative 'head_circumference/head_circumference_status_search_test'
require_relative 'head_circumference/head_circumference_category_search_test'
require_relative 'head_circumference/head_circumference_code_search_test'
require_relative 'head_circumference/head_circumference_date_search_test'
require_relative 'head_circumference/head_circumference_patient_search_test'
require_relative 'head_circumference/head_circumference_patient_category_date_search_test'
require_relative 'head_circumference/head_circumference_patient_category_status_search_test'
require_relative 'head_circumference/head_circumference_patient_code_date_search_test'
require_relative 'head_circumference/head_circumference_patient_category_search_test'
require_relative 'head_circumference/head_circumference_read_test'

module USCore
  class HeadCircumferenceGroup < Inferno::TestGroup
    title 'HeadCircumference Tests'
    # description ''

    id :head_circumference

    test from: :head_circumference_patient_code_search_test
    test from: :head_circumference_status_search_test
    test from: :head_circumference_category_search_test
    test from: :head_circumference_code_search_test
    test from: :head_circumference_date_search_test
    test from: :head_circumference_patient_search_test
    test from: :head_circumference_patient_category_date_search_test
    test from: :head_circumference_patient_category_status_search_test
    test from: :head_circumference_patient_code_date_search_test
    test from: :head_circumference_patient_category_search_test
    test from: :head_circumference_read_test
  end
end
