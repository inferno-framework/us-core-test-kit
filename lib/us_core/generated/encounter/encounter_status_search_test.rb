require_relative '../../search_test'

module USCore
  class EncounterStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Encounter search by status'
    description %(
      A server MAY support searching by status on the Encounter resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :encounter_status_search_test

    def resource_type
      'Encounter'
    end

    def scratch_resources
      scratch[:encounter_resources] ||= []
    end

    def search_params
      {
        'status': search_param_value('status')
      }
    end

    run do
      perform_search_test
    end
  end
end