# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class CoverageClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v610_coverage_client_support_test
        title 'Support Coverage Resource Access'
        description %(
          
            This test checks whether the client made requests for the Coverage FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-coverage` for the US Core Coverage Profile.
          
        )

        output :coverage_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Coverage`."
        end

        run do
          coverage_read_requests = load_tagged_requests(READ_COVERAGE_TAG)
          coverage_search_requests = load_tagged_requests(SEARCH_COVERAGE_TAG)
          coverage_support = 
            coverage_read_requests.length > 0 ||
            coverage_search_requests.length > 0
          if parent_optional?
            omit_if !coverage_support, skip_message
          else
            skip_if !coverage_support, skip_message
          end

          (output coverage_support:)
        end
      end
    end
  end
end
