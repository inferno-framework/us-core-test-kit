require_relative '../../search_test'

module USCore
  class GoalPatientLifecycleStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Goal search by patient + lifecycle-status'
    description %(
      A server SHOULD support searching by patient + lifecycle-status on the Goal resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :goal_patient_lifecycle_status_search_test

    input :patient_id, default: '85'

    def resource_type
      'Goal'
    end

    def scratch_resources
      scratch[:goal_resources] ||= []
    end

    def search_params
      {
        'patient': patient_id,
        'lifecycle-status': search_param_value('lifecycleStatus')
      }
    end

    run do
      perform_search_test
    end
  end
end
