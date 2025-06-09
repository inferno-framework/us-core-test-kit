# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class QuestionnaireResponseClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v610_questionnaire_response_client_support_test
        title 'Support QuestionnaireResponse Resource Access'
        description %(
          
            This test checks whether the client made requests for the QuestionnaireResponse FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-questionnaire-response` for the US Core QuestionnaireResponse Profile.
          
        )

        output :questionnaire_response_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `QuestionnaireResponse`."
        end

        run do
          questionnaire_response_read_requests = load_tagged_requests(READ_QUESTIONNAIRE_RESPONSE_TAG)
          questionnaire_response_search_requests = load_tagged_requests(SEARCH_QUESTIONNAIRE_RESPONSE_TAG)
          questionnaire_response_support = 
            questionnaire_response_read_requests.length > 0 ||
            questionnaire_response_search_requests.length > 0
          if parent_optional?
            omit_if !questionnaire_response_support, skip_message
          else
            skip_if !questionnaire_response_support, skip_message
          end

          (output questionnaire_response_support:)
        end
      end
    end
  end
end
