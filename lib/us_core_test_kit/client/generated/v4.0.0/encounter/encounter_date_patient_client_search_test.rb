# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class EncounterDatePatientClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_encounter_date_patient_client_search_test

        title 'SHALL support date + patient search of Encounter'

        description %(
          The client demonstrates SHALL support for searching date + patient on Encounter.
        )

        def required_params
          ["date", "patient"]
        end

        def failure_message
          "Did not receive a request for `Encounter` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_ENCOUNTER_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Encounter')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
