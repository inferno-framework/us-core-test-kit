require_relative 'device/device_patient_search_test'
require_relative 'device/device_type_search_test'
require_relative 'device/device_patient_type_search_test'
require_relative 'device/device_read_test'
require_relative 'device/device_validation_test'

module USCore
  class DeviceGroup < Inferno::TestGroup
    title 'Device Tests'
    # description ''

    id :device

    test from: :device_patient_search_test
    test from: :device_type_search_test
    test from: :device_patient_type_search_test
    test from: :device_read_test
    test from: :device_validation_test
  end
end
