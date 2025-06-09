# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class ConditionClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v400_condition_client_read_test
        title 'SHALL support read of Condition'
        description %(
          The client demonstrates SHALL support for reading Condition.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Condition` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Condition Profile: `Condition/us-core-client-tests-condition-encounter-diagnosis`."
        end

        run do
          requests = load_tagged_requests(READ_CONDITION_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-condition-encounter-diagnosis')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
