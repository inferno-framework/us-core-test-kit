# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class ServiceRequestClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v800_service_request_client_read_test
        title 'SHALL support read of ServiceRequest'
        description %(
          The client demonstrates SHALL support for reading ServiceRequest.
        )

        def skip_message
          "Inferno did not receive any read requests for the `ServiceRequest` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core ServiceRequest Profile: `ServiceRequest/us-core-client-tests-service-request`."
        end

        run do
          requests = load_tagged_requests(READ_SERVICE_REQUEST_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-service-request')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
