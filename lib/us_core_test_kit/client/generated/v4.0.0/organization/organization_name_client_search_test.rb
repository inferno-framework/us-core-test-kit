# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class OrganizationNameClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_organization_name_client_search_test
        title 'SHOULD support name search of Organization'
        description %(
          The client demonstrates SHOULD support for searching name on Organization.
        )
        optional true

        input :organization_support,
              optional: true

        def required_params
          ["name"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Organization` resource type, so support for US Core Organization Profile is not expected."
        end

        def failure_message
          "No searches made for the `Organization` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if organization_support.blank?, skip_message
          else
            skip_if organization_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_ORGANIZATION_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
