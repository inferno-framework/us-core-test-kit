# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class PractitionerRoleSpecialtyClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v610_practitioner_role_specialty_client_search_test

        title 'SHALL support specialty search of PractitionerRole'

        description %(
          The client demonstrates SHALL support for searching specialty on PractitionerRole.
        )

        def required_params
          ["specialty"]
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
