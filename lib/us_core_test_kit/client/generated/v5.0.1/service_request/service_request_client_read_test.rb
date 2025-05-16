# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class ServiceRequestClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v501_service_request_client_read_test

        title 'SHALL support read of ServiceRequest'

        description %(
          The client demonstrates SHALL support for reading ServiceRequest.
        )

        def failure_message
          "Did not receive a request for `ServiceRequest` with id: `us-core-client-tests-service-request`."
        end

        run do
          requests = load_tagged_requests(READ_SERVICE_REQUEST_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'ServiceRequest')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-service-request')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
