require_relative '../../search_test'

module USCore
  class PulseOximetryStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by status'
    description %(
      A server MAY support searching by status on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :pulse_oximetry_status_search_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:pulse_oximetry_resources] = [] if scratch[:pulse_oximetry_resources].nil?
      scratch[:pulse_oximetry_resources]
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
