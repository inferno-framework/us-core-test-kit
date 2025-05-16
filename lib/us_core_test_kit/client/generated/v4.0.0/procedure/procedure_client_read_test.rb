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

        def failure_message
          "Did not receive a request for `Procedure` with id: `us-core-client-tests-procedure`."
        end

        run do
          requests = load_tagged_requests(READ_PROCEDURE_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Procedure')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-procedure')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
