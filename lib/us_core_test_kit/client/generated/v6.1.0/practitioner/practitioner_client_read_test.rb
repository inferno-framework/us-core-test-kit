# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class PractitionerClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_practitioner_client_read_test

        verifies_requirements 'hl7.fhir.us.core_6.1.0@314'
        title 'SHALL support read of Practitioner'
        description %(
          The client demonstrates SHALL support for reading Practitioner.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Practitioner` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Practitioner Profile: `Practitioner/us-core-client-tests-practitioner`."
        end

        run do
          requests = load_tagged_requests(READ_PRACTITIONER_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-practitioner')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
