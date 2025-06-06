# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class PatientClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_patient_client_read_test
        title 'SHALL support read of Patient'
        description %(
          The client demonstrates SHALL support for reading Patient.
        )

        input :patient_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Patient` resource type, so support for US Core Patient Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Patient Profile: `Patient/us-core-client-tests-patient`."
        end

        run do
          if parent_optional?
            omit_if patient_support.blank?, skip_message
          else
            skip_if patient_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_PATIENT_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-patient')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
