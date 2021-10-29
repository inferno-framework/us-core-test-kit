require_relative 'care_plan_read_test'

module USCore
  class CarePlanGroup < Inferno::TestGroup
    title 'CarePlan Tests'
    # description ''

    id :care_plan

    test from: :care_plan_read_test
  end
end
