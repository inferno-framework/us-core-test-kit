# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class PractitionerRoleClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_practitioner_role_client_read_test

        verifies_requirements 'hl7.fhir.us.core_6.1.0@315'
        title 'SHALL support read of PractitionerRole'

        description %(
          The client demonstrates SHALL support for reading PractitionerRole.
        )

        def failure_message
          "Did not receive a request for `PractitionerRole` with id: `us-core-client-tests-practitioner-role`."
        end

        run do
          requests = load_tagged_requests(READ_PRACTITIONER_ROLE_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'PractitionerRole')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-practitioner-role')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
