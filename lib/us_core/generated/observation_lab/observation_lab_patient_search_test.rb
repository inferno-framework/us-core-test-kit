require_relative '../../search_test'

module USCore
  class ObservationLabPatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient'
    description %(
      A server MAY support searching by patient on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :observation_lab_patient_search_test

    input :patient_id, default: '85'

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:observation_lab_resources] = [] if scratch[:observation_lab_resources].nil?
      scratch[:observation_lab_resources]
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
