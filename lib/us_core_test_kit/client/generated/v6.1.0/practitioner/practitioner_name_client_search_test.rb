# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class PractitionerNameClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v610_practitioner_name_client_search_test
        title 'SHALL support name search of Practitioner'
        description %(
          The client demonstrates SHALL support for searching name on Practitioner.
        )
        optional false

        def required_params
          ["name"]
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
