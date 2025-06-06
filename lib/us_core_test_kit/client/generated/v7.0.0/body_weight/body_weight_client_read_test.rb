# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class BodyWeightClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_body_weight_client_read_test
        title 'SHALL support read of BodyWeight'
        description %(
          The client demonstrates SHALL support for reading BodyWeight.
        )

        input :observation_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Observation` resource type, so support for US Core Body Weight Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Body Weight Profile: `Observation/us-core-client-tests-body-weight`."
        end

        run do
          if parent_optional?
            omit_if observation_support.blank?, skip_message
          else
            skip_if observation_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_OBSERVATION_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-body-weight')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
