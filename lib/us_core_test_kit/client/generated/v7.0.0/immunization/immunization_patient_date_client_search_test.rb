# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class ImmunizationPatientDateClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_immunization_patient_date_client_search_test
        title 'SHOULD support patient + date search of Immunization'
        description %(
          The client demonstrates SHOULD support for searching patient + date on Immunization.
        )
        optional true

        def required_params
          ["patient", "date"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `Immunization` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `Immunization` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_IMMUNIZATION_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
