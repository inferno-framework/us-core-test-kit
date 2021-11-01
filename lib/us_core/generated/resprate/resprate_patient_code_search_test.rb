require_relative '../../search_test'

module USCore
  class RespratePatientCodeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient + code'
    description %(
      A server SHALL support searching by patient + code on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :resprate_patient_code_search_test

    input :patient_id, default: '85'

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:resprate_resources] ||= []
    end

    def search_params
      {
        'patient': patient_id,
        'code': search_param_value('code')
      }
    end

    run do
      perform_search_test
    end
  end
end
