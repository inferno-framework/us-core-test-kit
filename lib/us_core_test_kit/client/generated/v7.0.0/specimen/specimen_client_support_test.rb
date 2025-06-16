# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class SpecimenClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v700_specimen_client_support_test
        title 'Support Specimen Resource Access'
        description %(
          
            This test checks whether the client made requests for the Specimen FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-specimen` for the US Core Specimen Profile.
          
        )

        output :specimen_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Specimen`."
        end

        run do
          specimen_read_requests = load_tagged_requests(READ_SPECIMEN_TAG)
          specimen_search_requests = load_tagged_requests(SEARCH_SPECIMEN_TAG)
          specimen_support = 
            specimen_read_requests.length > 0 ||
            specimen_search_requests.length > 0
          if parent_optional?
            omit_if !specimen_support, skip_message
          else
            skip_if !specimen_support, skip_message
          end

          (output specimen_support:)
        end
      end
    end
  end
end
