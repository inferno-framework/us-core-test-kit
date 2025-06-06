# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class PulseOximetryPatientClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v311_pulse_oximetry_patient_client_search_test
        title 'SHOULD support patient search of PulseOximetry'
        description %(
          The client demonstrates SHOULD support for searching patient on PulseOximetry.
        )
        optional true

        input :observation_support,
              optional: true

        def required_params
          ["patient"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Observation` resource type, so support for US Core Pulse Oximetry Profile is not expected."
        end

        def failure_message
          "No searches made for the `Observation` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if observation_support.blank?, skip_message
          else
            skip_if observation_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_OBSERVATION_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
