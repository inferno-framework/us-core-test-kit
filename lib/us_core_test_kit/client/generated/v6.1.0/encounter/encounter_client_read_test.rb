# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class EncounterClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_encounter_client_read_test
        title 'SHALL support read of Encounter'
        description %(
          The client demonstrates SHALL support for reading Encounter.
        )

        input :encounter_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Encounter` resource type, so support for US Core Encounter Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Encounter Profile: `Encounter/us-core-client-tests-encounter`."
        end

        run do
          if parent_optional?
            omit_if encounter_support.blank?, skip_message
          else
            skip_if encounter_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_ENCOUNTER_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-encounter')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
