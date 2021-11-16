require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class EncounterIdentifierSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Encounter search by identifier'
    description %(
      A server SHOULD support searching by identifier on the Encounter resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :encounter_identifier_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Encounter',
        search_param_names: ['identifier'],
        possible_status_search: true
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:encounter_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
