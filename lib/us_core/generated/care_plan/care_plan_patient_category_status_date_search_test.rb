require_relative '../../search_test'

module USCore
  class CarePlanPatientCategoryStatusDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for CarePlan search by patient + category + status + date'
    description %(
      A server SHOULD support searching by patient + category + status + date on the CarePlan resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :care_plan_patient_category_status_date_search_test

    input :patient_id, default: '85'

    def resource_type
      'CarePlan'
    end

    def scratch_resources
      scratch[:care_plan_resources] ||= []
    end

    def search_params
      {
        'patient': patient_id,
        'category': search_param_value('category'),
        'status': search_param_value('status'),
        'date': search_param_value('period')
      }
    end

    run do
      perform_search_test
    end
  end
end
