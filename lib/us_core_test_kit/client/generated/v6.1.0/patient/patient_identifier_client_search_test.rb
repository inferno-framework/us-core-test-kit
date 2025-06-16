# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class PatientIdentifierClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v610_patient_identifier_client_search_test
        title 'SHALL support identifier search of Patient'
        description %(
          The client demonstrates SHALL support for searching identifier on Patient.
        )
        optional false

        def required_params
          ["identifier"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `Patient` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `Patient` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_PATIENT_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
