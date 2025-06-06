# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class ProcedureClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v400_procedure_client_read_test
        title 'SHALL support read of Procedure'
        description %(
          The client demonstrates SHALL support for reading Procedure.
        )

        input :procedure_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Procedure` resource type, so support for US Core Procedure Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Procedure Profile: `Procedure/us-core-client-tests-procedure`."
        end

        run do
          if parent_optional?
            omit_if procedure_support.blank?, skip_message
          else
            skip_if procedure_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_PROCEDURE_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-procedure')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
