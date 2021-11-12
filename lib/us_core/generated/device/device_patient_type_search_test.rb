require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class DevicePatientTypeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Device search by patient + type'
    description %(
      A server SHOULD support searching by patient + type on the Device resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :device_patient_type_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Device',
        search_param_names: ['patient', 'type']
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
