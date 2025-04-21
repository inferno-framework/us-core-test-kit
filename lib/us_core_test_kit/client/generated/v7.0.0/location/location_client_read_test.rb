# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class LocationClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_location_client_read_test

        title 'SHALL support read of Location'

        description %(
          The client demonstrates SHALL support for reading Location.
        )

        def failure_message
          "Did not receive a request for `Location` with id: `us-core-client-tests-location`."
        end

        run do
          requests = load_tagged_requests(READ_LOCATION_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Location')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-location')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
