require_relative '../../search_test'

module USCore
  class ImmunizationStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Immunization search by status'
    description %(
      A server MAY support searching by status on the Immunization resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :immunization_status_search_test

    def resource_type
      'Immunization'
    end

    def scratch_resources
      scratch[:immunization_resources] = [] if scratch[:immunization_resources].nil?
      scratch[:immunization_resources]
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
