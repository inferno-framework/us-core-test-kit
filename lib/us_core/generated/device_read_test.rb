require_relative '../read_test'

module USCore
  class DeviceReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Device resource from Device read interaction'
    description 'A server SHALL support the Device read interaction.'

    id :device_read_test

    def resource_type
      'Device'
    end

    run do
      perform_read_test(scratch[:device_resources])
    end
  end
end
