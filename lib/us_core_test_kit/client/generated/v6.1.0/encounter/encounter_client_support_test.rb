# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class EncounterClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v610_encounter_client_support_test
        title 'Support Encounter Resource Access'
        description %(
          
            This test checks whether the client made requests for the Encounter FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-encounter` for the US Core Encounter Profile.
          
        )

        output :encounter_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Encounter`."
        end

        run do
          encounter_read_requests = load_tagged_requests(READ_ENCOUNTER_TAG)
          encounter_search_requests = load_tagged_requests(SEARCH_ENCOUNTER_TAG)
          encounter_support = 
            encounter_read_requests.length > 0 ||
            encounter_search_requests.length > 0
          if parent_optional?
            omit_if !encounter_support, skip_message
          else
            skip_if !encounter_support, skip_message
          end

          (output encounter_support:)
        end
      end
    end
  end
end
