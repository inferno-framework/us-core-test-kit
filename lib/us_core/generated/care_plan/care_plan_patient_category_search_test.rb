require_relative '../../search_test'

module USCore
  class CarePlanPatientCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for CarePlan search by patient + category'
    description %(
      A server SHALL support searching by patient + category on the CarePlan resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :care_plan_patient_category_search_test

    input :patient_id, default: '85'

    def resource_type
      'CarePlan'
    end

    def scratch_resources
      scratch[:care_plan_resources] = [] if scratch[:care_plan_resources].nil?
      scratch[:care_plan_resources]
    end

    def search_params
      {
        'patient': patient_id,
        'category': search_param_value(find_a_value_at(scratch_resources, 'category'))
      }
    end

    run do
      perform_search_test
    end
  end
end
