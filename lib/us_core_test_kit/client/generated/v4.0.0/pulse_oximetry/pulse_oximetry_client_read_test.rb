# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class PulseOximetryClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v400_pulse_oximetry_client_read_test
        title 'SHALL support read of PulseOximetry'
        description %(
          The client demonstrates SHALL support for reading PulseOximetry.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Observation` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Pulse Oximetry Profile: `Observation/us-core-client-tests-pulse-oximetry`."
        end

        run do
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-pulse-oximetry')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
