# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class GoalClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v700_goal_client_support_test
        title 'Support Goal Resource Access'
        description %(
          
            This test checks whether the client made requests for the Goal FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-goal` for the US Core Goal Profile.
          
        )

        output :goal_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Goal`."
        end

        run do
          goal_read_requests = load_tagged_requests(READ_GOAL_TAG)
          goal_search_requests = load_tagged_requests(SEARCH_GOAL_TAG)
          goal_support = 
            goal_read_requests.length > 0 ||
            goal_search_requests.length > 0
          if parent_optional?
            omit_if !goal_support, skip_message
          else
            skip_if !goal_support, skip_message
          end

          (output goal_support:)
        end
      end
    end
  end
end
