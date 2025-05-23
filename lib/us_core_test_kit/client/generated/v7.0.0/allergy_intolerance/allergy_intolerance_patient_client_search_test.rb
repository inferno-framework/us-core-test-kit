# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class AllergyIntolerancePatientClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_allergy_intolerance_patient_client_search_test

        title 'SHALL support patient search of AllergyIntolerance'

        description %(
          The client demonstrates SHALL support for searching patient on AllergyIntolerance.
        )

        def required_params
          ["patient"]
        end

        def failure_message
          "Did not receive a request for `AllergyIntolerance` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_ALLERGY_INTOLERANCE_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'AllergyIntolerance')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
