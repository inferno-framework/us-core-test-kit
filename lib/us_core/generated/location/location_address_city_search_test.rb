require_relative '../../search_test'

module USCore
  class LocationAddressCitySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Location search by address-city'
    description %(
      A server SHOULD support searching by address-city on the Location resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :location_address_city_search_test

    def resource_type
      'Location'
    end

    def scratch_resources
      scratch[:location_resources] ||= []
    end

    def search_params
      {
        'address-city': search_param_value('address.city')
      }
    end

    run do
      perform_search_test
    end
  end
end
