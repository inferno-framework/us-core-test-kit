# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class QuestionnaireResponsePatientTagClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_questionnaire_response_patient_tag_client_search_test
        title 'SHOULD support patient + _tag search of QuestionnaireResponse'
        description %(
          The client demonstrates SHOULD support for searching patient + _tag on QuestionnaireResponse.
        )
        optional true

        input :questionnaire_response_support,
              optional: true

        def required_params
          ["patient", "_tag"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `QuestionnaireResponse` resource type, so support for US Core QuestionnaireResponse Profile is not expected."
        end

        def failure_message
          "No searches made for the `QuestionnaireResponse` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if questionnaire_response_support.blank?, skip_message
          else
            skip_if questionnaire_response_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_QUESTIONNAIRE_RESPONSE_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
