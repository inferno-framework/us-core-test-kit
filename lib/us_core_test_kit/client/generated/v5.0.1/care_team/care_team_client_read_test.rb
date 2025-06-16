# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class CareTeamClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v501_care_team_client_read_test
        title 'SHALL support read of CareTeam'
        description %(
          The client demonstrates SHALL support for reading CareTeam.
        )

        def skip_message
          "Inferno did not receive any read requests for the `CareTeam` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core CareTeam Profile: `CareTeam/us-core-client-tests-care-team`."
        end

        run do
          requests = load_tagged_requests(READ_CARE_TEAM_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-care-team')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
