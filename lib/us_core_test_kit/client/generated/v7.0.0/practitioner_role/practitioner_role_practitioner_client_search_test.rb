# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class PractitionerRolePractitionerClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_practitioner_role_practitioner_client_search_test

        title 'SHALL support practitioner search of PractitionerRole'

        description %(
          The client demonstrates SHALL support for searching practitioner on PractitionerRole.
        )

        def required_params
          ["practitioner"]
        end

        def failure_message
          "Did not recieve a request for `PractitionerRole` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_PRACTITIONER_ROLE_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'PractitionerRole')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
