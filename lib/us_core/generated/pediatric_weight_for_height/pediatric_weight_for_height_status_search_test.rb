require_relative '../../search_test'

module USCore
  class PediatricWeightForHeightStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by status'
    description %(
      A server MAY support searching by status on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :pediatric_weight_for_height_status_search_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:pediatric_weight_for_height_resources] = [] if scratch[:pediatric_weight_for_height_resources].nil?
      scratch[:pediatric_weight_for_height_resources]
    end

    def search_params
      {
        'status': search_param_value(find_a_value_at(scratch_resources, 'status'))
      }
    end

    run do
      perform_search_test
    end
  end
end
