require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class PulseOximetryCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by category'
    description %(
      A server MAY support searching by category on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :pulse_oximetry_category_search_test

    def resource_type
      'Observation'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:pulse_oximetry_resources] ||= []
    end

    def search_param_names
      ['category']
    end

    run do
      perform_search_test
    end
  end
end
