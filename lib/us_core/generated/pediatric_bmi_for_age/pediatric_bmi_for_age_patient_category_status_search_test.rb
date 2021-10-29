require_relative '../../search_test'

module USCore
  class PediatricBmiForAgePatientCategoryStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient + category + status'
    description %(
      A server SHOULD support searching by patient + category + status on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :pediatric_bmi_for_age_patient_category_status_search_test

    input :patient_id, default: '85'

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:pediatric_bmi_for_age_resources] = [] if scratch[:pediatric_bmi_for_age_resources].nil?
      scratch[:pediatric_bmi_for_age_resources]
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
