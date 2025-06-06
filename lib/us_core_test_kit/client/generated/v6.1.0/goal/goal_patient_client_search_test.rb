# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class GoalPatientClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v610_goal_patient_client_search_test
        title 'SHALL support patient search of Goal'
        description %(
          The client demonstrates SHALL support for searching patient on Goal.
        )
        optional false

        input :goal_support,
              optional: true

        def required_params
          ["patient"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Goal` resource type, so support for US Core Goal Profile is not expected."
        end

        def failure_message
          "No searches made for the `Goal` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if goal_support.blank?, skip_message
          else
            skip_if goal_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_GOAL_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
