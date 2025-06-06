# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class DeviceClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v501_device_client_support_test
        title 'Support Device Resource Access'
        description %(
          
            This test checks whether the client made requests for the Device FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-device` for the US Core Implantable Device Profile.
          
        )

        output :device_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `Device`."
        end

        run do
          device_read_requests = load_tagged_requests(READ_DEVICE_TAG)
          device_search_requests = load_tagged_requests(SEARCH_DEVICE_TAG)
          device_support = 
            device_read_requests.length > 0 ||
            device_search_requests.length > 0
          if parent_optional?
            omit_if !device_support, skip_message
          else
            skip_if !device_support, skip_message
          end

          (output device_support:)
        end
      end
    end
  end
end
