# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class CarePlanPatientCategoryDateClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v311_care_plan_patient_category_date_client_search_test
        title 'SHOULD support patient + category + date search of CarePlan'
        description %(
          The client demonstrates SHOULD support for searching patient + category + date on CarePlan.
        )
        optional true

        def required_params
          ["patient", "category", "date"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `CarePlan` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `CarePlan` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_CARE_PLAN_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
