# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class CareTeamClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_care_team_client_read_test

        title 'SHALL support read of CareTeam'

        description %(
          The client demonstrates SHALL support for reading CareTeam.
        )

        def failure_message
          "Did not receive a request for `CareTeam` with id: `us-core-client-tests-care-team`."
        end

        run do
          requests = load_tagged_requests(READ_CARE_TEAM_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'CareTeam')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-care-team')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
