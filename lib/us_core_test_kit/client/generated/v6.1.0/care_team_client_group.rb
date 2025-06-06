# frozen_string_literal: true

require_relative 'care_team/care_team_client_support_test'
require_relative 'care_team/care_team_client_read_test'
require_relative 'care_team/care_team_patient_status_client_search_test'
require_relative 'care_team/care_team_role_client_search_test'
require_relative 'care_team/care_team_patient_role_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class CareTeamClientGroup < Inferno::TestGroup
        id :us_core_client_v610_care_team
        title 'CareTeam'
        description %(
          
# Background

This test group verifies that the client can access CareTeam data
conforming to the US Core CareTeam Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the CareTeam FHIR resource type. However, if they
do support it, they must support the US Core CareTeam Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
CareTeam resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-care-team`

## Searching
These tests will check that the client performed searches agains the
CareTeam resource type with the following required parameters:

* patient + status

Inferno will also look for searches using the following optional parameters:

* role
* patient + role


        )
        optional true
        run_as_group

        test from: :us_core_v610_care_team_client_support_test
        test from: :us_core_v610_care_team_client_read_test
        test from: :us_core_v610_care_team_patient_status_client_search_test
        test from: :us_core_v610_care_team_role_client_search_test
        test from: :us_core_v610_care_team_patient_role_client_search_test
      end
    end
  end
end
