require_relative '../../search_test'

module USCore
  class OrganizationNameSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Organization search by name'
    description %(
      A server SHALL support searching by name on the Organization resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :organization_name_search_test

    def resource_type
      'Organization'
    end

    def scratch_resources
      scratch[:organization_resources] = [] if scratch[:organization_resources].nil?
      scratch[:organization_resources]
    end

    def search_params
      {
        'name': search_param_value(find_a_value_at(scratch_resources, 'name'))
      }
    end

    run do
      perform_search_test
    end
  end
end
