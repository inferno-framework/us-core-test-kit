# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class PatientClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v311_patient_client_read_test

        title 'SHALL support read of Patient'

        description %(
          The client demonstrates SHALL support for reading Patient.
        )

        def failure_message
          "Did not receive a request for `Patient` with id: `us-core-client-tests-patient`."
        end

        run do
          requests = load_tagged_requests(READ_PATIENT_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Patient')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-patient')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
