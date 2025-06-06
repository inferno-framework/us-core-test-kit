# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class MedicationRequestPatientIntentClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_medication_request_patient_intent_client_search_test
        title 'SHALL support patient + intent search of MedicationRequest'
        description %(
          The client demonstrates SHALL support for searching patient + intent on MedicationRequest.
        )
        optional false

        input :medication_request_support,
              optional: true

        def required_params
          ["patient", "intent"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `MedicationRequest` resource type, so support for US Core MedicationRequest Profile is not expected."
        end

        def failure_message
          "No searches made for the `MedicationRequest` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if medication_request_support.blank?, skip_message
          else
            skip_if medication_request_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_MEDICATION_REQUEST_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
