# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class HeartRateClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v800_heart_rate_client_read_test
        title 'SHALL support read of HeartRate'
        description %(
          The client demonstrates SHALL support for reading HeartRate.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Observation` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Heart Rate Profile: `Observation/us-core-client-tests-heart-rate`."
        end

        run do
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-heart-rate')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
