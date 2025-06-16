# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class ProcedurePatientClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_procedure_patient_client_search_test
        title 'SHALL support patient search of Procedure'
        description %(
          The client demonstrates SHALL support for searching patient on Procedure.
        )
        optional false

        def required_params
          ["patient"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `Procedure` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `Procedure` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_PROCEDURE_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
