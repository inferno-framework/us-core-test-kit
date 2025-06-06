# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class PractitionerRoleClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_practitioner_role_client_read_test
        title 'SHALL support read of PractitionerRole'
        description %(
          The client demonstrates SHALL support for reading PractitionerRole.
        )

        input :practitioner_role_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `PractitionerRole` resource type, so support for US Core PractitionerRole Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core PractitionerRole Profile: `PractitionerRole/us-core-client-tests-practitioner-role`."
        end

        run do
          if parent_optional?
            omit_if practitioner_role_support.blank?, skip_message
          else
            skip_if practitioner_role_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_PRACTITIONER_ROLE_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-practitioner-role')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
