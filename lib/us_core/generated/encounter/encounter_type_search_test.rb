require_relative '../../search_test'

module USCore
  class EncounterTypeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Encounter search by type'
    description %(
      A server MAY support searching by type on the Encounter resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :encounter_type_search_test

    def resource_type
      'Encounter'
    end

    def scratch_resources
      scratch[:encounter_resources] ||= []
    end

    def search_params
      {
        'type': search_param_value('type')
      }
    end

    run do
      perform_search_test
    end
  end
end
