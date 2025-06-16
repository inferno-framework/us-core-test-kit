# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class EncounterClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v400_encounter_client_read_test
        title 'SHALL support read of Encounter'
        description %(
          The client demonstrates SHALL support for reading Encounter.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Encounter` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Encounter Profile: `Encounter/us-core-client-tests-encounter`."
        end

        run do
          requests = load_tagged_requests(READ_ENCOUNTER_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-encounter')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
