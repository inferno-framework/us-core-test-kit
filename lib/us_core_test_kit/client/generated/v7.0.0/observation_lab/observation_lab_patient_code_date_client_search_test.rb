# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class ObservationLabPatientCodeDateClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_observation_lab_patient_code_date_client_search_test
        title 'SHOULD support patient + code + date search of ObservationLab'
        description %(
          The client demonstrates SHOULD support for searching patient + code + date on ObservationLab.
        )
        optional true

        def required_params
          ["patient", "code", "date"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `Observation` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `Observation` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_OBSERVATION_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
