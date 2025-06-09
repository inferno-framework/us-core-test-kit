# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class MedicationRequestClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v610_medication_request_client_support_test
        title 'Support MedicationRequest Resource Access'
        description %(
          
            This test checks whether the client made requests for the MedicationRequest FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-medication-request` for the US Core MedicationRequest Profile.
          
        )

        output :medication_request_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `MedicationRequest`."
        end

        run do
          medication_request_read_requests = load_tagged_requests(READ_MEDICATION_REQUEST_TAG)
          medication_request_search_requests = load_tagged_requests(SEARCH_MEDICATION_REQUEST_TAG)
          medication_request_support = 
            medication_request_read_requests.length > 0 ||
            medication_request_search_requests.length > 0
          if parent_optional?
            omit_if !medication_request_support, skip_message
          else
            skip_if !medication_request_support, skip_message
          end

          (output medication_request_support:)
        end
      end
    end
  end
end
