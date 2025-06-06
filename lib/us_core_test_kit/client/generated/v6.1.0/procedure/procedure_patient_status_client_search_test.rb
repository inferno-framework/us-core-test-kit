# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class ProcedurePatientStatusClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v610_procedure_patient_status_client_search_test
        title 'SHOULD support patient + status search of Procedure'
        description %(
          The client demonstrates SHOULD support for searching patient + status on Procedure.
        )
        optional true

        input :procedure_support,
              optional: true

        def required_params
          ["patient", "status"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Procedure` resource type, so support for US Core Procedure Profile is not expected."
        end

        def failure_message
          "No searches made for the `Procedure` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if procedure_support.blank?, skip_message
          else
            skip_if procedure_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_PROCEDURE_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
