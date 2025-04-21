# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class ConditionProblemsHealthConcernsPatientClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_condition_problems_health_concerns_patient_client_search_test

        title 'SHALL support patient search of ConditionProblemsHealthConcerns'

        description %(
          The client demonstrates SHALL support for searching patient on ConditionProblemsHealthConcerns.
        )

        def required_params
          ["patient"]
        end

        def failure_message
          "Did not recieve a request for `Condition` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_CONDITION_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Condition')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
