# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class HeadCircumferencePatientCategoryStatusClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_head_circumference_patient_category_status_client_search_test
        title 'SHOULD support patient + category + status search of HeadCircumference'
        description %(
          The client demonstrates SHOULD support for searching patient + category + status on HeadCircumference.
        )
        optional true

        def required_params
          ["patient", "category", "status"]
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
