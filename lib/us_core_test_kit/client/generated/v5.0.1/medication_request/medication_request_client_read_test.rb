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

        def skip_message
          "Inferno did not receive any read requests for the `MedicationRequest` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core MedicationRequest Profile: `MedicationRequest/us-core-client-tests-medication-request`."
        end

        run do
          requests = load_tagged_requests(READ_MEDICATION_REQUEST_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-medication-request')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
