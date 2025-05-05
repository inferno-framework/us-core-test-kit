# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class MedicationRequestPatientIntentStatusClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_medication_request_patient_intent_status_client_search_test

        title 'SHALL support patient + intent + status search of MedicationRequest'

        description %(
          The client demonstrates SHALL support for searching patient + intent + status on MedicationRequest.
        )

        def required_params
          ["patient", "intent", "status"]
        end

        def failure_message
          "Did not receive a request for `MedicationRequest` with required search parameters: `#{required_params.join(' + ')}`"
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
