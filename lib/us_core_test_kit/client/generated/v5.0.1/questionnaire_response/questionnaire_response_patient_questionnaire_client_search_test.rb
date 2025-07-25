# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class QuestionnaireResponsePatientQuestionnaireClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_questionnaire_response_patient_questionnaire_client_search_test
        title 'SHOULD support patient + questionnaire search of QuestionnaireResponse'
        description %(
          The client demonstrates SHOULD support for searching patient + questionnaire on QuestionnaireResponse.
        )
        optional true

        def required_params
          ["patient", "questionnaire"]
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
