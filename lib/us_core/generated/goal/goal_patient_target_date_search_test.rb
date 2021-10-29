require_relative '../../search_test'

module USCore
  class GoalPatientTargetDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Goal search by patient + target-date'
    description %(
      A server SHOULD support searching by patient + target-date on the Goal resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :goal_patient_target_date_search_test

    input :patient_id, default: '85'

    def resource_type
      'Goal'
    end

    def scratch_resources
      scratch[:goal_resources] = [] if scratch[:goal_resources].nil?
      scratch[:goal_resources]
    end

    def search_params
      {
        'patient': patient_id,
        'target-date': search_param_value(find_a_value_at(scratch_resources, '(target.due as date)'))
      }
    end

    run do
      perform_search_test
    end
  end
end
