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

        def required_params
          ["identifier"]
        end

        def failure_message
          "Did not receive a request for `Patient` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_PATIENT_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Patient')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
