# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class GoalClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v501_goal_client_read_test
        title 'SHALL support read of Goal'
        description %(
          The client demonstrates SHALL support for reading Goal.
        )

        input :goal_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Goal` resource type, so support for US Core Goal Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Goal Profile: `Goal/us-core-client-tests-goal`."
        end

        run do
          if parent_optional?
            omit_if goal_support.blank?, skip_message
          else
            skip_if goal_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_GOAL_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-goal')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
