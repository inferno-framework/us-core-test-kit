require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_patient_code_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_status_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_category_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_code_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_date_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_patient_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_patient_category_date_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_patient_category_status_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_patient_code_date_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_patient_category_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_read_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_provenance_revinclude_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_validation_test'

module USCore
  class PediatricBmiForAgeGroup < Inferno::TestGroup
    title 'PediatricBmiForAge Tests'
    # description ''

    id :pediatric_bmi_for_age

    test from: :pediatric_bmi_for_age_patient_code_search_test
    test from: :pediatric_bmi_for_age_status_search_test
    test from: :pediatric_bmi_for_age_category_search_test
    test from: :pediatric_bmi_for_age_code_search_test
    test from: :pediatric_bmi_for_age_date_search_test
    test from: :pediatric_bmi_for_age_patient_search_test
    test from: :pediatric_bmi_for_age_patient_category_date_search_test
    test from: :pediatric_bmi_for_age_patient_category_status_search_test
    test from: :pediatric_bmi_for_age_patient_code_date_search_test
    test from: :pediatric_bmi_for_age_patient_category_search_test
    test from: :pediatric_bmi_for_age_read_test
    test from: :pediatric_bmi_for_age_provenance_revinclude_search_test
    test from: :pediatric_bmi_for_age_validation_test
  end
end
