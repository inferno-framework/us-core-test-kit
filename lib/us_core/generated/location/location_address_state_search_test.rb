require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class LocationAddressStateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Location search by address-state'
    description %(
      A server SHOULD support searching by address-state on the Location resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :location_address_state_search_test

    def resource_type
      'Location'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:location_resources] ||= []
    end

    def search_param_names
      ['address-state']
    end

    run do
      perform_search_test
    end
  end
end
