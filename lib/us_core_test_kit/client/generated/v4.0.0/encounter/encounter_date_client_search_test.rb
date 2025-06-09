# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class EncounterDateClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_encounter_date_client_search_test
        title 'SHOULD support date search of Encounter'
        description %(
          The client demonstrates SHOULD support for searching date on Encounter.
        )
        optional true

        def required_params
          ["date"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `Encounter` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `Encounter` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_ENCOUNTER_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
