require_relative '../../reference_resolution_test'

module USCore
  class DeviceReferenceResolutionTest < Inferno::Test
    include USCore::ReferenceResolutionTest

    title 'Every reference within Device resources can be read'
    description %(
      This test will attempt to read the first 50 references found in the
      resources from the first search. The test will fail if Inferno fails to
      read any of those references.
    )

    id :device_reference_resolution_test

    def resource_type
      'Device'
    end

    def scratch_resources
      scratch[:device_resources] ||= {}
    end

    run do
      perform_reference_resolution_test(scratch_resources[:all])
    end
  end
end
