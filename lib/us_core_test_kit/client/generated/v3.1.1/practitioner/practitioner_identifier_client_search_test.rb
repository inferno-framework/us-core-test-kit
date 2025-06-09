# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class PractitionerIdentifierClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v311_practitioner_identifier_client_search_test
        title 'SHOULD support identifier search of Practitioner'
        description %(
          The client demonstrates SHOULD support for searching identifier on Practitioner.
        )
        optional true

        def required_params
          ["identifier"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `Practitioner` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `Practitioner` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_PRACTITIONER_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
