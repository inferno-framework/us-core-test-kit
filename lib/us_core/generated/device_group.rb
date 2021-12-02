require_relative 'device/device_patient_search_test'
require_relative 'device/device_patient_type_search_test'
require_relative 'device/device_read_test'
require_relative 'device/device_provenance_revinclude_search_test'
require_relative 'device/device_validation_test'
require_relative 'device/device_must_support_test'

module USCore
  class DeviceGroup < Inferno::TestGroup
    title 'Device Tests'
    # description ''

    id :device

    test from: :device_patient_search_test
    test from: :device_patient_type_search_test
    test from: :device_read_test
    test from: :device_provenance_revinclude_search_test
    test from: :device_validation_test
    test from: :device_must_support_test
  end
end
