# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class RelatedPersonClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v700_related_person_client_support_test
        title 'Support RelatedPerson Resource Access'
        description %(
          
            This test checks whether the client made requests for the RelatedPerson FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-related-person` for the US Core RelatedPerson Profile.
          
        )

        output :related_person_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `RelatedPerson`."
        end

        run do
          related_person_read_requests = load_tagged_requests(READ_RELATED_PERSON_TAG)
          related_person_search_requests = load_tagged_requests(SEARCH_RELATED_PERSON_TAG)
          related_person_support = 
            related_person_read_requests.length > 0 ||
            related_person_search_requests.length > 0
          if parent_optional?
            omit_if !related_person_support, skip_message
          else
            skip_if !related_person_support, skip_message
          end

          (output related_person_support:)
        end
      end
    end
  end
end
