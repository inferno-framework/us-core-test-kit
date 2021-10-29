require_relative 'goal/goal_read_test'

module USCore
  class GoalGroup < Inferno::TestGroup
    title 'Goal Tests'
    # description ''

    id :goal

    test from: :goal_read_test
  end
end
