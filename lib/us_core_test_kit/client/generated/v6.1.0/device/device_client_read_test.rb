# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV610
      class DeviceClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v610_device_client_read_test
        title 'SHALL support read of Device'
        description %(
          The client demonstrates SHALL support for reading Device.
        )

        input :device_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Device` resource type, so support for US Core Implantable Device Profile is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Implantable Device Profile: `Device/us-core-client-tests-device`."
        end

        run do
          if parent_optional?
            omit_if device_support.blank?, skip_message
          else
            skip_if device_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_DEVICE_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-device')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
