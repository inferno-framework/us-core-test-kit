# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class CareTeamClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v400_care_team_client_read_test
        title 'SHALL support read of CareTeam'
        description %(
          The client demonstrates SHALL support for reading CareTeam.
        )

        input :care_team_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `CareTeam` resource type, so support for US Core CareTeam Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core CareTeam Profile: `CareTeam/us-core-client-tests-care-team`."
        end

        run do
          if parent_optional?
            omit_if care_team_support.blank?, skip_message
          else
            skip_if care_team_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_CARE_TEAM_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-care-team')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
