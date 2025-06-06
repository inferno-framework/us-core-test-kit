# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class OrganizationClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v311_organization_client_read_test
        title 'SHALL support read of Organization'
        description %(
          The client demonstrates SHALL support for reading Organization.
        )

        input :organization_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Organization` resource type, so support for US Core Organization Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Organization Profile: `Organization/us-core-client-tests-organization`."
        end

        run do
          if parent_optional?
            omit_if organization_support.blank?, skip_message
          else
            skip_if organization_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_ORGANIZATION_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-organization')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
