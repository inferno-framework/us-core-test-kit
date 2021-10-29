require_relative 'condition_read_test'

module USCore
  class ConditionGroup < Inferno::TestGroup
    title 'Condition Tests'
    # description ''

    id :condition

    test from: :condition_read_test
  end
end
