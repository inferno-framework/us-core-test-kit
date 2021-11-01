require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class EncounterIdSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Encounter search by _id'
    description %(
      A server SHALL support searching by _id on the Encounter resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :encounter__id_search_test

    def resource_type
      'Encounter'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:encounter_resources] ||= []
    end

    def search_params
      {
        '_id': search_param_value('id')
      }
    end

    run do
      perform_search_test
    end
  end
end
