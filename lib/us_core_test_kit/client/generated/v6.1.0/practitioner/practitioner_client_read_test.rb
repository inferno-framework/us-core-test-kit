# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class PractitionerClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_practitioner_client_read_test
        title 'SHALL support read of Practitioner'
        description %(
          The client demonstrates SHALL support for reading Practitioner.
        )

        input :practitioner_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Practitioner` resource type, so support for US Core Practitioner Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Practitioner Profile: `Practitioner/us-core-client-tests-practitioner`."
        end

        run do
          if parent_optional?
            omit_if practitioner_support.blank?, skip_message
          else
            skip_if practitioner_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_PRACTITIONER_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-practitioner')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
