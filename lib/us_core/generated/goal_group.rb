require_relative 'goal/goal_patient_search_test'
require_relative 'goal/goal_patient_lifecycle_status_search_test'
require_relative 'goal/goal_patient_target_date_search_test'
require_relative 'goal/goal_read_test'
require_relative 'goal/goal_provenance_revinclude_search_test'
require_relative 'goal/goal_validation_test'
require_relative 'goal/goal_must_support_test'
require_relative 'goal/goal_reference_resolution_test'

module USCore
  class GoalGroup < Inferno::TestGroup
    title 'Goal Tests'
    # description ''

    id :goal

    test from: :goal_patient_search_test
    test from: :goal_patient_lifecycle_status_search_test
    test from: :goal_patient_target_date_search_test
    test from: :goal_read_test
    test from: :goal_provenance_revinclude_search_test
    test from: :goal_validation_test
    test from: :goal_must_support_test
    test from: :goal_reference_resolution_test
  end
end
