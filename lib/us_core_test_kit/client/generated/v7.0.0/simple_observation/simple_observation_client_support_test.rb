# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class SimpleObservationClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v700_simple_observation_client_support_test
        title 'Support Observation Resource Access'
        description %(
          
            This test checks whether the client made requests for the Observation FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-simple-observation` for the US Core Simple Observation Profile.
          
        )

        output :observation_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Observation`."
        end

        run do
          observation_read_requests = load_tagged_requests(READ_OBSERVATION_TAG)
          observation_search_requests = load_tagged_requests(SEARCH_OBSERVATION_TAG)
          observation_support = 
            observation_read_requests.length > 0 ||
            observation_search_requests.length > 0
          if parent_optional?
            omit_if !observation_support, skip_message
          else
            skip_if !observation_support, skip_message
          end

          (output observation_support:)
        end
      end
    end
  end
end
