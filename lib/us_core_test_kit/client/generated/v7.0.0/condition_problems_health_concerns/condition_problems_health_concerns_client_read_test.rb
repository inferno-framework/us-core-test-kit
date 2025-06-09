# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class ConditionProblemsHealthConcernsClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_condition_problems_health_concerns_client_read_test
        title 'SHALL support read of ConditionProblemsHealthConcerns'
        description %(
          The client demonstrates SHALL support for reading ConditionProblemsHealthConcerns.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Condition` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Condition Problems and Health Concerns Profile: `Condition/us-core-client-tests-condition-problems-health-concerns`."
        end

        run do
          requests = load_tagged_requests(READ_CONDITION_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-condition-problems-health-concerns')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
