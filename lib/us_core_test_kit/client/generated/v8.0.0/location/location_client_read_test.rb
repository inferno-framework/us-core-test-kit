# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class LocationClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v800_location_client_read_test
        title 'SHALL support read of Location'
        description %(
          The client demonstrates SHALL support for reading Location.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Location` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Location Profile: `Location/us-core-client-tests-location`."
        end

        run do
          requests = load_tagged_requests(READ_LOCATION_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-location')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
