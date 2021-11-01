require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class GoalLifecycleStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Goal search by lifecycle-status'
    description %(
      A server MAY support searching by lifecycle-status on the Goal resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :goal_lifecycle_status_search_test

    def resource_type
      'Goal'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:goal_resources] ||= []
    end

    def search_params
      {
        'lifecycle-status': search_param_value('lifecycleStatus')
      }
    end

    run do
      perform_search_test
    end
  end
end
