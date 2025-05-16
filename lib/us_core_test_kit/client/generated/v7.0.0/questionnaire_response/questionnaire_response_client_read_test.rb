# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class QuestionnaireResponseClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_questionnaire_response_client_read_test

        title 'SHOULD support read of QuestionnaireResponse'

        description %(
          The client demonstrates SHOULD support for reading QuestionnaireResponse.
        )

        def failure_message
          "Did not receive a request for `QuestionnaireResponse` with id: `us-core-client-tests-questionnaire-response`."
        end

        run do
          requests = load_tagged_requests(READ_QUESTIONNAIRE_RESPONSE_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'QuestionnaireResponse')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-questionnaire-response')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
