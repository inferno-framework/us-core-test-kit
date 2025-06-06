# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class CareTeamClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v501_care_team_client_support_test
        title 'Support CareTeam Resource Access'
        description %(
          
            This test checks whether the client made requests for the CareTeam FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-care-team` for the US Core CareTeam Profile.
          
        )

        output :care_team_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `CareTeam`."
        end

        run do
          care_team_read_requests = load_tagged_requests(READ_CARE_TEAM_TAG)
          care_team_search_requests = load_tagged_requests(SEARCH_CARE_TEAM_TAG)
          care_team_support = 
            care_team_read_requests.length > 0 ||
            care_team_search_requests.length > 0
          if parent_optional?
            omit_if !care_team_support, skip_message
          else
            skip_if !care_team_support, skip_message
          end

          (output care_team_support:)
        end
      end
    end
  end
end
