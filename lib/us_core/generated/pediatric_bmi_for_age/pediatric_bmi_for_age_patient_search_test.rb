require_relative '../../search_test'

module USCore
  class PediatricBmiForAgePatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient'
    description %(
      A server MAY support searching by patient on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :pediatric_bmi_for_age_patient_search_test

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
        'patient': patient_id
      }
    end

    run do
      perform_search_test
    end
  end
end
