# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class DocumentReferenceClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v610_document_reference_client_support_test
        title 'Support DocumentReference Resource Access'
        description %(
          
            This test checks whether the client made requests for the DocumentReference FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-document-reference` for the US Core DocumentReference Profile.
          
        )

        output :document_reference_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `DocumentReference`."
        end

        run do
          document_reference_read_requests = load_tagged_requests(READ_DOCUMENT_REFERENCE_TAG)
          document_reference_search_requests = load_tagged_requests(SEARCH_DOCUMENT_REFERENCE_TAG)
          document_reference_support = 
            document_reference_read_requests.length > 0 ||
            document_reference_search_requests.length > 0
          if parent_optional?
            omit_if !document_reference_support, skip_message
          else
            skip_if !document_reference_support, skip_message
          end

          (output document_reference_support:)
        end
      end
    end
  end
end
