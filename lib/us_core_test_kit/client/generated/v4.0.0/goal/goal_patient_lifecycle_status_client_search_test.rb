# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class GoalPatientLifecycleStatusClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_goal_patient_lifecycle_status_client_search_test
        title 'SHOULD support patient + lifecycle-status search of Goal'
        description %(
          The client demonstrates SHOULD support for searching patient + lifecycle-status on Goal.
        )
        optional true

        def required_params
          ["patient", "lifecycle-status"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `Goal` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `Goal` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_GOAL_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
