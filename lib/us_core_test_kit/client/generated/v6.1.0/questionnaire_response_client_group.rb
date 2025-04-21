# frozen_string_literal: true

require_relative 'questionnaire_response/questionnaire_response_client_read_test'
require_relative 'questionnaire_response/questionnaire_response_patient_client_search_test'
require_relative 'questionnaire_response/questionnaire_response_id_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class QuestionnaireResponseClientGroup < Inferno::TestGroup
        id :us_core_client_v610_questionnaire_response

        title 'QuestionnaireResponse'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required QuestionnaireResponse queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-questionnaire-response`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient
* _id

        )

        run_as_group

        test from: :us_core_v610_questionnaire_response_client_read_test
        test from: :us_core_v610_questionnaire_response_patient_client_search_test
        test from: :us_core_v610_questionnaire_response_id_client_search_test
      end
    end
  end
end
