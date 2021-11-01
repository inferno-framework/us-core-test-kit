require_relative '../../search_test'

module USCore
  class BodyweightPatientCodeDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient + code + date'
    description %(
      A server SHOULD support searching by patient + code + date on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :bodyweight_patient_code_date_search_test

    input :patient_id, default: '85'

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:bodyweight_resources] ||= []
    end

    def search_params
      {
        'patient': patient_id,
        'code': search_param_value('code'),
        'date': search_param_value('effective')
      }
    end

    run do
      perform_search_test
    end
  end
end
