require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV700
    class DeviceReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Device resource from Device read interaction'
      description 'A server SHALL support the Device read interaction.'

      id :us_core_v700_device_read_test

      def resource_type
        'Device'
      end

      def scratch_resources
        scratch[:device_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
