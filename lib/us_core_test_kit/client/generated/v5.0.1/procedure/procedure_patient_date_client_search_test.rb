# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class ProcedurePatientDateClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_procedure_patient_date_client_search_test

        title 'SHALL support patient + date search of Procedure'

        description %(
          The client demonstrates SHALL support for searching patient + date on Procedure.
        )

        def required_params
          ["patient", "date"]
        end

        def failure_message
          "Did not receive a request for `Procedure` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_PROCEDURE_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Procedure')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
