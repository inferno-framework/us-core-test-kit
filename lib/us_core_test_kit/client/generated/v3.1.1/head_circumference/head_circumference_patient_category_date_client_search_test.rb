# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class HeadCircumferencePatientCategoryDateClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v311_head_circumference_patient_category_date_client_search_test

        title 'SHALL support patient + category + date search of HeadCircumference'

        description %(
          The client demonstrates SHALL support for searching patient + category + date on HeadCircumference.
        )

        def required_params
          ["patient", "category", "date"]
        end

        def failure_message
          "Did not recieve a request for `Observation` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_OBSERVATION_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Observation')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
