# frozen_string_literal: true

require_relative 'care_team/care_team_client_read_test'
require_relative 'care_team/care_team_patient_status_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class CareTeamClientGroup < Inferno::TestGroup
        id :us_core_client_v311_care_team

        title 'CareTeam'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required CareTeam queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-care-team`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + status

        )

        run_as_group

        test from: :us_core_v311_care_team_client_read_test
        test from: :us_core_v311_care_team_patient_status_client_search_test
      end
    end
  end
end
