# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class QuestionnaireResponsePatientStatusClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v800_questionnaire_response_patient_status_client_search_test
        title 'SHOULD support patient + status search of QuestionnaireResponse'
        description %(
          The client demonstrates SHOULD support for searching patient + status on QuestionnaireResponse.
        )
        optional true

        def required_params
          ["patient", "status"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `QuestionnaireResponse` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `QuestionnaireResponse` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_QUESTIONNAIRE_RESPONSE_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
