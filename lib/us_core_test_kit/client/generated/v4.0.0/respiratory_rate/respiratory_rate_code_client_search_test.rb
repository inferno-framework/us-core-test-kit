# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class RespiratoryRateCodeClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_respiratory_rate_code_client_search_test
        title 'SHOULD support code search of RespiratoryRate'
        description %(
          The client demonstrates SHOULD support for searching code on RespiratoryRate.
        )
        optional true

        def required_params
          ["code"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `Observation` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `Observation` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_OBSERVATION_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
