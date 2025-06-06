# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class ServiceRequestClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v700_service_request_client_support_test
        title 'Support ServiceRequest Resource Access'
        description %(
          
            This test checks whether the client made requests for the ServiceRequest FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-service-request` for the US Core ServiceRequest Profile.
          
        )

        output :service_request_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `ServiceRequest`."
        end

        run do
          service_request_read_requests = load_tagged_requests(READ_SERVICE_REQUEST_TAG)
          service_request_search_requests = load_tagged_requests(SEARCH_SERVICE_REQUEST_TAG)
          service_request_support = 
            service_request_read_requests.length > 0 ||
            service_request_search_requests.length > 0
          if parent_optional?
            omit_if !service_request_support, skip_message
          else
            skip_if !service_request_support, skip_message
          end

          (output service_request_support:)
        end
      end
    end
  end
end
