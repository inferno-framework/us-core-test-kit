# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class QuestionnaireResponseClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_questionnaire_response_client_read_test
        title 'SHOULD support read of QuestionnaireResponse'
        description %(
          The client demonstrates SHOULD support for reading QuestionnaireResponse.
        )

        input :questionnaire_response_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `QuestionnaireResponse` resource type, so support for US Core QuestionnaireResponse Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core QuestionnaireResponse Profile: `QuestionnaireResponse/us-core-client-tests-questionnaire-response`."
        end

        run do
          if parent_optional?
            omit_if questionnaire_response_support.blank?, skip_message
          else
            skip_if questionnaire_response_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_QUESTIONNAIRE_RESPONSE_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-questionnaire-response')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
