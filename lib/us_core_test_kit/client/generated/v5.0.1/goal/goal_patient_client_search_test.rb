# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class GoalPatientClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_goal_patient_client_search_test

        title 'SHALL support patient search of Goal'

        description %(
          The client demonstrates SHALL support for searching patient on Goal.
        )

        def required_params
          ["patient"]
        end

        def failure_message
          "Did not receive a request for `Goal` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_GOAL_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Goal')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
