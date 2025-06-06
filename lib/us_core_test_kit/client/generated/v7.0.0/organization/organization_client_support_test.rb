# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class OrganizationClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v700_organization_client_support_test
        title 'Support Organization Resource Access'
        description %(
          
            This test checks whether the client made requests for the Organization FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-organization` for the US Core Organization Profile.
          
        )

        output :organization_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Organization`."
        end

        run do
          organization_read_requests = load_tagged_requests(READ_ORGANIZATION_TAG)
          organization_search_requests = load_tagged_requests(SEARCH_ORGANIZATION_TAG)
          organization_support = 
            organization_read_requests.length > 0 ||
            organization_search_requests.length > 0
          if parent_optional?
            omit_if !organization_support, skip_message
          else
            skip_if !organization_support, skip_message
          end

          (output organization_support:)
        end
      end
    end
  end
end
