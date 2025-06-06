# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class EncounterDatePatientClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_encounter_date_patient_client_search_test
        title 'SHOULD support date + patient search of Encounter'
        description %(
          The client demonstrates SHOULD support for searching date + patient on Encounter.
        )
        optional true

        input :encounter_support,
              optional: true

        def required_params
          ["date", "patient"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Encounter` resource type, so support for US Core Encounter Profile is not expected."
        end

        def failure_message
          "No searches made for the `Encounter` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if encounter_support.blank?, skip_message
          else
            skip_if encounter_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_ENCOUNTER_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
