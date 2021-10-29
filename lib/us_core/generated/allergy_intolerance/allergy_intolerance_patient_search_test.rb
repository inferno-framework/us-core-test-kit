require_relative '../../search_test'

module USCore
  class AllergyIntolerancePatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for AllergyIntolerance search by patient'
    description %(
      A server SHALL support searching by patient on the AllergyIntolerance resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :allergy_intolerance_patient_search_test

    input :patient_id, default: '85'

    def resource_type
      'AllergyIntolerance'
    end

    def scratch_resources
      scratch[:allergy_intolerance_resources] = [] if scratch[:allergy_intolerance_resources].nil?
      scratch[:allergy_intolerance_resources]
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
