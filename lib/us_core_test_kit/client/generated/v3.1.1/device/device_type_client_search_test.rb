# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class DeviceTypeClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v311_device_type_client_search_test
        title 'SHOULD support type search of Device'
        description %(
          The client demonstrates SHOULD support for searching type on Device.
        )
        optional true

        input :device_support,
              optional: true

        def required_params
          ["type"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `Device` resource type, so support for US Core Implantable Device Profile is not expected."
        end

        def failure_message
          "No searches made for the `Device` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if device_support.blank?, skip_message
          else
            skip_if device_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_DEVICE_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
