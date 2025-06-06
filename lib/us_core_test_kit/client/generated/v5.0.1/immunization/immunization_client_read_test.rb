# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class ImmunizationClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v501_immunization_client_read_test
        title 'SHALL support read of Immunization'
        description %(
          The client demonstrates SHALL support for reading Immunization.
        )

        input :immunization_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Immunization` resource type, so support for US Core Immunization Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Immunization Profile: `Immunization/us-core-client-tests-immunization`."
        end

        run do
          if parent_optional?
            omit_if immunization_support.blank?, skip_message
          else
            skip_if immunization_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_IMMUNIZATION_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-immunization')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
