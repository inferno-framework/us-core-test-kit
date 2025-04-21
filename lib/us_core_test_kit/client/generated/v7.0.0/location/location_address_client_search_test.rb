# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class LocationAddressClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_location_address_client_search_test

        title 'SHALL support address search of Location'

        description %(
          The client demonstrates SHALL support for searching address on Location.
        )

        def required_params
          ["address"]
        end

        def failure_message
          "Did not recieve a request for `Location` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_LOCATION_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Location')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
