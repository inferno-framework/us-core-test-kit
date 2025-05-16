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

        def failure_message
          "Did not receive a request for `Condition` with id: `us-core-client-tests-condition-problems-health-concerns`."
        end

        run do
          requests = load_tagged_requests(READ_CONDITION_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Condition')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-condition-problems-health-concerns')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
