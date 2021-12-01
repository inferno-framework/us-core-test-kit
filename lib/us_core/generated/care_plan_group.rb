require_relative 'care_plan/care_plan_patient_search_test'
require_relative 'care_plan/care_plan_category_search_test'
require_relative 'care_plan/care_plan_date_search_test'
require_relative 'care_plan/care_plan_status_search_test'
require_relative 'care_plan/care_plan_patient_category_status_date_search_test'
require_relative 'care_plan/care_plan_patient_category_status_search_test'
require_relative 'care_plan/care_plan_patient_category_search_test'
require_relative 'care_plan/care_plan_patient_category_date_search_test'
require_relative 'care_plan/care_plan_read_test'
require_relative 'care_plan/care_plan_validation_test'

module USCore
  class CarePlanGroup < Inferno::TestGroup
    title 'CarePlan Tests'
    # description ''

    id :care_plan

    test from: :care_plan_patient_search_test
    test from: :care_plan_category_search_test
    test from: :care_plan_date_search_test
    test from: :care_plan_status_search_test
    test from: :care_plan_patient_category_status_date_search_test
    test from: :care_plan_patient_category_status_search_test
    test from: :care_plan_patient_category_search_test
    test from: :care_plan_patient_category_date_search_test
    test from: :care_plan_read_test
    test from: :care_plan_validation_test
  end
end
