# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class CareTeamPatientRoleClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v800_care_team_patient_role_client_search_test
        title 'SHOULD support patient + role search of CareTeam'
        description %(
          The client demonstrates SHOULD support for searching patient + role on CareTeam.
        )
        optional true

        def required_params
          ["patient", "role"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `CareTeam` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `CareTeam` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_CARE_TEAM_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
