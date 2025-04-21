# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class CareTeamPatientStatusClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v610_care_team_patient_status_client_search_test

        title 'SHALL support patient + status search of CareTeam'

        description %(
          The client demonstrates SHALL support for searching patient + status on CareTeam.
        )

        def required_params
          ["patient", "status"]
        end

        def failure_message
          "Did not recieve a request for `CareTeam` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_CARE_TEAM_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'CareTeam')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
