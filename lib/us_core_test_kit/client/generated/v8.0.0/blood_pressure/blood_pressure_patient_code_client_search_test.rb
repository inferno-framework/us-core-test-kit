# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class BloodPressurePatientCodeClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v800_blood_pressure_patient_code_client_search_test
        title 'SHALL support patient + code search of BloodPressure'
        description %(
          The client demonstrates SHALL support for searching patient + code on BloodPressure.
        )
        optional false

        def required_params
          ["patient", "code"]
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
