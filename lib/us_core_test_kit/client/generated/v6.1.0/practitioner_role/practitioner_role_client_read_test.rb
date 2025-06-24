# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class PractitionerRoleClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_practitioner_role_client_read_test
        title 'SHALL support read of PractitionerRole'
        description %(
          The client demonstrates SHALL support for reading PractitionerRole.
        )
        verifies_requirements 'hl7.fhir.us.core_6.1.0@315'

        def skip_message
          "Inferno did not receive any read requests for the `PractitionerRole` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core PractitionerRole Profile: `PractitionerRole/us-core-client-tests-practitioner-role`."
        end

        run do
          requests = load_tagged_requests(READ_PRACTITIONER_ROLE_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-practitioner-role')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
