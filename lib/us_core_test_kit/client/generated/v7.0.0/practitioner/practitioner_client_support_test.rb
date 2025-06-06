# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class PractitionerClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v700_practitioner_client_support_test
        title 'Support Practitioner Resource Access'
        description %(
          
            This test checks whether the client made requests for the Practitioner FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-practitioner` for the US Core Practitioner Profile.
          
        )

        output :practitioner_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Practitioner`."
        end

        run do
          practitioner_read_requests = load_tagged_requests(READ_PRACTITIONER_TAG)
          practitioner_search_requests = load_tagged_requests(SEARCH_PRACTITIONER_TAG)
          practitioner_support = 
            practitioner_read_requests.length > 0 ||
            practitioner_search_requests.length > 0
          if parent_optional?
            omit_if !practitioner_support, skip_message
          else
            skip_if !practitioner_support, skip_message
          end

          (output practitioner_support:)
        end
      end
    end
  end
end
