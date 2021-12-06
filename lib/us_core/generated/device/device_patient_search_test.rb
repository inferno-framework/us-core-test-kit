require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class DevicePatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Device search by patient'
    description %(
A server SHALL support searching by
patient on the Device resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

This test verifies that the server supports searching by reference using
the form `patient=[id]` as well as `patient=Patient/[id]`. The two
different forms are expected to return the same number of results. US
Core requires that both forms are supported by US Core responders.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :device_patient_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    input :implantable_device_codes,
      title: 'Implantable Device Type Code',
      description: 'Enter the code for an Implantable Device type, or multiple codes separated by commas. '\
                   'If blank, Inferno will validate all Device resources against the Implantable Device profile',
      optional: true

    def properties
      @properties ||= SearchTestProperties.new(
        first_search: true,
        resource_type: 'Device',
        search_param_names: ['patient'],
        test_reference_variants: true
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:device_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
