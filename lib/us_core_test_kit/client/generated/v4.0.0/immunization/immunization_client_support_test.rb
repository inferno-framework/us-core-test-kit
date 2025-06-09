# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class ImmunizationClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v400_immunization_client_support_test
        title 'Support Immunization Resource Access'
        description %(
          
            This test checks whether the client made requests for the Immunization FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-immunization` for the US Core Immunization Profile.
          
        )

        output :immunization_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Immunization`."
        end

        run do
          immunization_read_requests = load_tagged_requests(READ_IMMUNIZATION_TAG)
          immunization_search_requests = load_tagged_requests(SEARCH_IMMUNIZATION_TAG)
          immunization_support = 
            immunization_read_requests.length > 0 ||
            immunization_search_requests.length > 0
          if parent_optional?
            omit_if !immunization_support, skip_message
          else
            skip_if !immunization_support, skip_message
          end

          (output immunization_support:)
        end
      end
    end
  end
end
