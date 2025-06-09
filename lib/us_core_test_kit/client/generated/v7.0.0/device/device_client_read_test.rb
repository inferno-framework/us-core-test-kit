# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class DeviceClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_device_client_read_test
        title 'SHALL support read of Device'
        description %(
          The client demonstrates SHALL support for reading Device.
        )

        def skip_message
          "Inferno did not receive any read requests for the `Device` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core Implantable Device Profile: `Device/us-core-client-tests-device`."
        end

        run do
          requests = load_tagged_requests(READ_DEVICE_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-device')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
