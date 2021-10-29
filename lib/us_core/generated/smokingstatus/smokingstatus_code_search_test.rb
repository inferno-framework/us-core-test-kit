require_relative '../../search_test'

module USCore
  class SmokingstatusCodeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by code'
    description %(
      A server MAY support searching by code on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :smokingstatus_code_search_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:smokingstatus_resources] = [] if scratch[:smokingstatus_resources].nil?
      scratch[:smokingstatus_resources]
    end

    def search_params
      {
        'code': search_param_value(find_a_value_at(scratch_resources, 'code'))
      }
    end

    run do
      perform_search_test
    end
  end
end
