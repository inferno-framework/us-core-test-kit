# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class MedicationRequestClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v501_medication_request_client_read_test
        title 'SHALL support read of MedicationRequest'
        description %(
          The client demonstrates SHALL support for reading MedicationRequest.
        )

        input :medication_request_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `MedicationRequest` resource type, so support for US Core MedicationRequest Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core MedicationRequest Profile: `MedicationRequest/us-core-client-tests-medication-request`."
        end

        run do
          if parent_optional?
            omit_if medication_request_support.blank?, skip_message
          else
            skip_if medication_request_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_MEDICATION_REQUEST_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-medication-request')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
