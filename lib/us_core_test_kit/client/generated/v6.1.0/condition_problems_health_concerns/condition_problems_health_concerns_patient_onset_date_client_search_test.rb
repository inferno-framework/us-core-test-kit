# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class ConditionProblemsHealthConcernsPatientOnsetDateClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v610_condition_problems_health_concerns_patient_onset_date_client_search_test
        title 'SHOULD support patient + onset-date search of ConditionProblemsHealthConcerns'
        description %(
          The client demonstrates SHOULD support for searching patient + onset-date on ConditionProblemsHealthConcerns.
        )
        optional true

        def required_params
          ["patient", "onset-date"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `Condition` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `Condition` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_CONDITION_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
