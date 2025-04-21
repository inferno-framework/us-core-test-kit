# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class DocumentReferenceClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_document_reference_client_read_test

        title 'SHALL support read of DocumentReference'

        description %(
          The client demonstrates SHALL support for reading DocumentReference.
        )

        def failure_message
          "Did not receive a request for `DocumentReference` with id: `us-core-client-tests-document-reference`."
        end

        run do
          requests = load_tagged_requests(READ_DOCUMENT_REFERENCE_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'DocumentReference')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-document-reference')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
