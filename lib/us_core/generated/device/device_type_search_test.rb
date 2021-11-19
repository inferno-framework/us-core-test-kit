require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class DeviceTypeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Device search by type'
    description %(
      A server MAY support searching by type on the Device resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :device_type_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Device',
        search_param_names: ['type'],
        token_search_params: ['type']
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
