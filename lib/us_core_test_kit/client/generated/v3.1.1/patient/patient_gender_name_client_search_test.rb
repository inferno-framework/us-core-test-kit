# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class PatientGenderNameClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v311_patient_gender_name_client_search_test
        title 'SHOULD support gender + name search of Patient'
        description %(
          The client demonstrates SHOULD support for searching gender + name on Patient.
        )
        optional true

        def required_params
          ["gender", "name"]
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
