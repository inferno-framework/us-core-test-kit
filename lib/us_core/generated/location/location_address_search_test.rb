require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class LocationAddressSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Location search by address'
    description %(
      A server SHALL support searching by address on the Location resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :location_address_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Location',
        search_param_names: ['address']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:location_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
