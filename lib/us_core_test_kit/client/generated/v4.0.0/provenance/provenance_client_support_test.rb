# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class ProvenanceClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v400_provenance_client_support_test
        title 'Support Provenance Resource Access'
        description %(
          
            This test checks whether the client made requests for the Provenance FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-provenance` for the US Core Provenance Profile.
          
        )

        output :provenance_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Provenance`."
        end

        run do
          provenance_read_requests = load_tagged_requests(READ_PROVENANCE_TAG)
          provenance_search_requests = load_tagged_requests(SEARCH_PROVENANCE_TAG)
          provenance_support = 
            provenance_read_requests.length > 0 ||
            provenance_search_requests.length > 0
          if parent_optional?
            omit_if !provenance_support, skip_message
          else
            skip_if !provenance_support, skip_message
          end

          (output provenance_support:)
        end
      end
    end
  end
end
