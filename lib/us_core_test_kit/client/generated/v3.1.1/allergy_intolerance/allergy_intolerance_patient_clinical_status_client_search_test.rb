# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class AllergyIntolerancePatientClinicalStatusClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v311_allergy_intolerance_patient_clinical_status_client_search_test
        title 'SHOULD support patient + clinical-status search of AllergyIntolerance'
        description %(
          The client demonstrates SHOULD support for searching patient + clinical-status on AllergyIntolerance.
        )
        optional true

        def required_params
          ["patient", "clinical-status"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `AllergyIntolerance` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `AllergyIntolerance` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_ALLERGY_INTOLERANCE_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
