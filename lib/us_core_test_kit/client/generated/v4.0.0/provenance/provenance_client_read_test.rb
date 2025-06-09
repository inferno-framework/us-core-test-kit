# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class ProvenanceClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v400_provenance_client_read_test
        title 'SHALL support read of Provenance'
        description %(
          The client demonstrates SHALL support for reading Provenance.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Provenance` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Provenance Profile: `Provenance/us-core-client-tests-provenance`."
        end

        run do
          requests = load_tagged_requests(READ_PROVENANCE_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-provenance')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
