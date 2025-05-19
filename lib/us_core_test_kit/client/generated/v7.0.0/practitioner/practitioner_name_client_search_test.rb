# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class PractitionerNameClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_practitioner_name_client_search_test

        title 'SHALL support name search of Practitioner'

        description %(
          The client demonstrates SHALL support for searching name on Practitioner.
        )

        def required_params
          ["name"]
        end

        def failure_message
          "Did not receive a request for `Practitioner` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_PRACTITIONER_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'Practitioner')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
