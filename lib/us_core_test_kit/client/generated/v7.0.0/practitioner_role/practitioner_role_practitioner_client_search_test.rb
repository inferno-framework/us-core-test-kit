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
        optional false

        input :practitioner_role_support,
              optional: true

        def required_params
          ["practitioner"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `PractitionerRole` resource type, so support for US Core PractitionerRole Profile is not expected."
        end

        def failure_message
          "No searches made for the `PractitionerRole` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if practitioner_role_support.blank?, skip_message
          else
            skip_if practitioner_role_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_PRACTITIONER_ROLE_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
