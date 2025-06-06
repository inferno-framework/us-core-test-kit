# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class BodyheightClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v311_bodyheight_client_read_test
        title 'SHALL support read of Bodyheight'
        description %(
          The client demonstrates SHALL support for reading Bodyheight.
        )

        input :observation_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Observation` resource type, so support for Observation Body Height Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the Observation Body Height Profile: `Observation/us-core-client-tests-body-height`."
        end

        run do
          if parent_optional?
            omit_if observation_support.blank?, skip_message
          else
            skip_if observation_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-body-height')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
