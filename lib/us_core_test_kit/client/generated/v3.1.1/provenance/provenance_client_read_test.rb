# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class ProvenanceClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v311_provenance_client_read_test
        title 'SHALL support read of Provenance'
        description %(
          The client demonstrates SHALL support for reading Provenance.
        )

        input :provenance_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Provenance` resource type, so support for US Core Provenance Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Provenance Profile: `Provenance/us-core-client-tests-provenance`."
        end

        run do
          if parent_optional?
            omit_if provenance_support.blank?, skip_message
          else
            skip_if provenance_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_PROVENANCE_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-provenance')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
