require_relative '../../validation_test'

module USCore
  class GoalValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Goal resources returned during previous tests conform to the US Core Goal Profile'
    # description ''

    id :goal_validation_test

    def resource_type
      'Goal'
    end

    def scratch_resources
      scratch[:goal_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal')
    end
  end
end
