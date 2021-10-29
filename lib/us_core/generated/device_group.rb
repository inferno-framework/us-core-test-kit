require_relative 'device/device_read_test'

module USCore
  class DeviceGroup < Inferno::TestGroup
    title 'Device Tests'
    # description ''

    id :device

    test from: :device_read_test
  end
end
