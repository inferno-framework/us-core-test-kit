require_relative 'goal/goal_patient_search_test'
require_relative 'goal/goal_lifecycle_status_search_test'
require_relative 'goal/goal_target_date_search_test'
require_relative 'goal/goal_patient_lifecycle_status_search_test'
require_relative 'goal/goal_patient_target_date_search_test'
require_relative 'goal/goal_read_test'
require_relative 'goal/goal_provenance_revinclude_search_test'
require_relative 'goal/goal_validation_test'

module USCore
  class GoalGroup < Inferno::TestGroup
    title 'Goal Tests'
    # description ''

    id :goal

    test from: :goal_patient_search_test
    test from: :goal_lifecycle_status_search_test
    test from: :goal_target_date_search_test
    test from: :goal_patient_lifecycle_status_search_test
    test from: :goal_patient_target_date_search_test
    test from: :goal_read_test
    test from: :goal_provenance_revinclude_search_test
    test from: :goal_validation_test
  end
end
