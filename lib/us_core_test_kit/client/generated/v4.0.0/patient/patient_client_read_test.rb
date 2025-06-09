# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class PatientClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v400_patient_client_read_test
        title 'SHALL support read of Patient'
        description %(
          The client demonstrates SHALL support for reading Patient.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Patient` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Patient Profile: `Patient/us-core-client-tests-patient`."
        end

        run do
          requests = load_tagged_requests(READ_PATIENT_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-patient')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
