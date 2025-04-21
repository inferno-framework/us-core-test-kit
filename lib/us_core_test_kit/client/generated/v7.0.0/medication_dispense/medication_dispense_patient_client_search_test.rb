# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class MedicationDispensePatientClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_medication_dispense_patient_client_search_test

        title 'SHALL support patient search of MedicationDispense'

        description %(
          The client demonstrates SHALL support for searching patient on MedicationDispense.
        )

        def required_params
          ["patient"]
        end

        def failure_message
          "Did not recieve a request for `MedicationDispense` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_MEDICATION_DISPENSE_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'MedicationDispense')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
