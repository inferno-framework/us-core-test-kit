require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ObservationLabStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by status'
    description %(
      A server MAY support searching by status on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :observation_lab_status_search_test

    def resource_type
      'Observation'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:observation_lab_resources] ||= []
    end

    def search_param_names
      ['status']
    end

    run do
      perform_search_test
    end
  end
end
