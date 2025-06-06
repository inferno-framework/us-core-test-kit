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

        input :document_reference_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `DocumentReference` resource type, so support for US Core DocumentReference Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core DocumentReference Profile: `DocumentReference/us-core-client-tests-document-reference`."
        end

        run do
          if parent_optional?
            omit_if document_reference_support.blank?, skip_message
          else
            skip_if document_reference_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_DOCUMENT_REFERENCE_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-document-reference')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
