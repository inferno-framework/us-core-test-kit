require_relative '../../search_test'

module USCore
  class CarePlanPatientCategoryStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for CarePlan search by patient + category + status'
    description %(
      A server SHOULD support searching by patient + category + status on the CarePlan resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :care_plan_patient_category_status_search_test

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
        'category': search_param_value(find_a_value_at(scratch_resources, 'category')),
        'status': search_param_value(find_a_value_at(scratch_resources, 'status'))
      }
    end

    run do
      perform_search_test
    end
  end
end
