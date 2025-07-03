# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class PediatricBmiForAgePatientCategoryLastupdatedClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v800_pediatric_bmi_for_age_patient_category_lastupdated_client_search_test
        title 'SHOULD support patient + category + _lastUpdated search of PediatricBmiForAge'
        description %(
          The client demonstrates SHOULD support for searching patient + category + _lastUpdated on PediatricBmiForAge.
        )
        optional true

        def required_params
          ["patient", "category", "_lastUpdated"]
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
