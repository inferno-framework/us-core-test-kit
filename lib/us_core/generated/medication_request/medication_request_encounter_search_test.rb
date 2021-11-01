require_relative '../../search_test'

module USCore
  class MedicationRequestEncounterSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for MedicationRequest search by encounter'
    description %(
      A server MAY support searching by encounter on the MedicationRequest resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :medication_request_encounter_search_test

    def resource_type
      'MedicationRequest'
    end

    def scratch_resources
      scratch[:medication_request_resources] ||= []
    end

    def search_params
      {
        'encounter': search_param_value('encounter')
      }
    end

    run do
      perform_search_test
    end
  end
end
