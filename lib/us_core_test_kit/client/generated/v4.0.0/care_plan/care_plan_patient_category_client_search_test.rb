# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class CarePlanPatientCategoryClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_care_plan_patient_category_client_search_test

        title 'SHALL support patient + category search of CarePlan'

        description %(
          The client demonstrates SHALL support for searching patient + category on CarePlan.
        )

        def required_params
          ["patient", "category"]
        end

        def failure_message
          "Did not recieve a request for `CarePlan` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_CARE_PLAN_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'CarePlan')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
