require_relative '../../search_test'

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

    def resource_type
      'Goal'
    end

    def scratch_resources
      scratch[:goal_resources] ||= []
    end

    def search_params
      {
        'target-date': search_param_value('target.dueDate')
      }
    end

    run do
      perform_search_test
    end
  end
end
