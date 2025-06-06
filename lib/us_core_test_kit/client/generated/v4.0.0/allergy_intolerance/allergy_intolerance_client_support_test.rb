# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class AllergyIntoleranceClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v400_allergy_intolerance_client_support_test
        title 'Support AllergyIntolerance Resource Access'
        description %(
          
            This test checks whether the client made requests for the AllergyIntolerance FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-allergy-intolerance` for the US Core AllergyIntolerance Profile.
          
        )

        output :allergy_intolerance_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `AllergyIntolerance`."
        end

        run do
          allergy_intolerance_read_requests = load_tagged_requests(READ_ALLERGY_INTOLERANCE_TAG)
          allergy_intolerance_search_requests = load_tagged_requests(SEARCH_ALLERGY_INTOLERANCE_TAG)
          allergy_intolerance_support = 
            allergy_intolerance_read_requests.length > 0 ||
            allergy_intolerance_search_requests.length > 0
          if parent_optional?
            omit_if !allergy_intolerance_support, skip_message
          else
            skip_if !allergy_intolerance_support, skip_message
          end

          (output allergy_intolerance_support:)
        end
      end
    end
  end
end
