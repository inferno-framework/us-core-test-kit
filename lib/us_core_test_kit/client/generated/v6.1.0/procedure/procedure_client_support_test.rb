# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class ProcedureClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v610_procedure_client_support_test
        title 'Support Procedure Resource Access'
        description %(
          
            This test checks whether the client made requests for the Procedure FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-procedure` for the US Core Procedure Profile.
          
        )

        output :procedure_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Procedure`."
        end

        run do
          procedure_read_requests = load_tagged_requests(READ_PROCEDURE_TAG)
          procedure_search_requests = load_tagged_requests(SEARCH_PROCEDURE_TAG)
          procedure_support = 
            procedure_read_requests.length > 0 ||
            procedure_search_requests.length > 0
          if parent_optional?
            omit_if !procedure_support, skip_message
          else
            skip_if !procedure_support, skip_message
          end

          (output procedure_support:)
        end
      end
    end
  end
end
