# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class MedicationRequestPatientIntentClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v311_medication_request_patient_intent_client_search_test

        title 'SHALL support patient + intent search of MedicationRequest'

        description %(
          The client demonstrates SHALL support for searching patient + intent on MedicationRequest.
        )

        def required_params
          ["patient", "intent"]
        end

        def failure_message
          "Did not recieve a request for `MedicationRequest` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_MEDICATION_REQUEST_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'MedicationRequest')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
