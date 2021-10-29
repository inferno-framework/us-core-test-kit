require_relative '../../search_test'

module USCore
  class OrganizationAddressSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Organization search by address'
    description %(
      A server SHALL support searching by address on the Organization resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :organization_address_search_test

    def resource_type
      'Organization'
    end

    def scratch_resources
      scratch[:organization_resources] = [] if scratch[:organization_resources].nil?
      scratch[:organization_resources]
    end

    def search_params
      {
        'address': search_param_value(find_a_value_at(scratch_resources, 'address'))
      }
    end

    run do
      perform_search_test
    end
  end
end
