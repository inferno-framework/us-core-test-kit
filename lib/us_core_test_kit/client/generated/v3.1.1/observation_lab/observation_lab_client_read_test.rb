# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class ObservationLabClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v311_observation_lab_client_read_test
        title 'SHALL support read of ObservationLab'
        description %(
          The client demonstrates SHALL support for reading ObservationLab.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Observation` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Laboratory Result Observation Profile: `Observation/us-core-client-tests-observation-lab`."
        end

        run do
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-observation-lab')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
