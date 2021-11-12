require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class GoalTargetDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Goal search by target-date'
    description %(
      A server MAY support searching by target-date on the Goal resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :goal_target_date_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Goal',
        search_param_names: ['target-date']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:goal_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
