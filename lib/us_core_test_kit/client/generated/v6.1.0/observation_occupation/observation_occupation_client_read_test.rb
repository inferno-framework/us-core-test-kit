# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class ObservationOccupationClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_observation_occupation_client_read_test
        title 'SHALL support read of ObservationOccupation'
        description %(
          The client demonstrates SHALL support for reading ObservationOccupation.
        )

        input :observation_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Observation` resource type, so support for US Core Observation Occupation Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Observation Occupation Profile: `Observation/us-core-client-tests-observation-occupation`."
        end

        run do
          if parent_optional?
            omit_if observation_support.blank?, skip_message
          else
            skip_if observation_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-observation-occupation')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
