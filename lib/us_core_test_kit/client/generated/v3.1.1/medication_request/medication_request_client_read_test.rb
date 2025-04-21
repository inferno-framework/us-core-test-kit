# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class MedicationRequestClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v311_medication_request_client_read_test

        title 'SHALL support read of MedicationRequest'

        description %(
          The client demonstrates SHALL support for reading MedicationRequest.
        )

        def failure_message
          "Did not receive a request for `MedicationRequest` with id: `us-core-client-tests-medication-request`."
        end

        run do
          requests = load_tagged_requests(READ_MEDICATION_REQUEST_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'MedicationRequest')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-medication-request')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
