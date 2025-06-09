# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class PractitionerRoleSpecialtyClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_practitioner_role_specialty_client_search_test
        title 'SHALL support specialty search of PractitionerRole'
        description %(
          The client demonstrates SHALL support for searching specialty on PractitionerRole.
        )
        optional false

        def required_params
          ["specialty"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `PractitionerRole` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `PractitionerRole` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_PRACTITIONER_ROLE_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
