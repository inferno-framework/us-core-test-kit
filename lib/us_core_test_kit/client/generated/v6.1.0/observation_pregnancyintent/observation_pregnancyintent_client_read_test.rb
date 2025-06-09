# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class ObservationPregnancyintentClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_observation_pregnancyintent_client_read_test
        title 'SHALL support read of ObservationPregnancyintent'
        description %(
          The client demonstrates SHALL support for reading ObservationPregnancyintent.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Observation` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Observation Pregnancy Intent Profile: `Observation/us-core-client-tests-observation-pregnancyintent`."
        end

        run do
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-observation-pregnancyintent')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
