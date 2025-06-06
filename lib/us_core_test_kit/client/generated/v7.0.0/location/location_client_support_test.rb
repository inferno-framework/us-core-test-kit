# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class LocationClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v700_location_client_support_test
        title 'Support Location Resource Access'
        description %(
          
            This test checks whether the client made requests for the Location FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-location` for the US Core Location Profile.
          
        )

        output :location_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Location`."
        end

        run do
          location_read_requests = load_tagged_requests(READ_LOCATION_TAG)
          location_search_requests = load_tagged_requests(SEARCH_LOCATION_TAG)
          location_support = 
            location_read_requests.length > 0 ||
            location_search_requests.length > 0
          if parent_optional?
            omit_if !location_support, skip_message
          else
            skip_if !location_support, skip_message
          end

          (output location_support:)
        end
      end
    end
  end
end
