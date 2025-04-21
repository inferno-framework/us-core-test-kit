# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class PatientGenderNameClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_patient_gender_name_client_search_test

        title 'SHALL support gender + name search of Patient'

        description %(
          The client demonstrates SHALL support for searching gender + name on Patient.
        )

        def required_params
          ["gender", "name"]
        end

        def failure_message
          "Did not recieve a request for `Patient` with required search parameters: `#{required_params.join(' + ')}`"
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
