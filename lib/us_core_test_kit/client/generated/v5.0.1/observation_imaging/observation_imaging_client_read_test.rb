# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class ObservationImagingClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v501_observation_imaging_client_read_test
        title 'SHALL support read of ObservationImaging'
        description %(
          The client demonstrates SHALL support for reading ObservationImaging.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Observation` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Observation Imaging Result Profile: `Observation/us-core-client-tests-observation-imaging`."
        end

        run do
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-observation-imaging')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
