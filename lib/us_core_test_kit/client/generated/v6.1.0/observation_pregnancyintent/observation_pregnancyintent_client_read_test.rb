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

        def failure_message
          "Did not receive a request for `Observation` with id: `us-core-client-tests-observation-pregnancyintent`."
        end

        run do
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Observation')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-observation-pregnancyintent')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
