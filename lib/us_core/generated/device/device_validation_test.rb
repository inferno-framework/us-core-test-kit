require_relative '../../validation_test'

module USCore
  class DeviceValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Device resources returned during previous tests conform to the US Core Implantable Device Profile'
    # description ''

    id :device_validation_test

    def resource_type
      'Device'
    end

    def scratch_resources
      scratch[:device_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device')
    end
  end
end
