require_relative '../../validation_test'

module USCore
  class ConditionValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Condition resources returned during previous tests conform to the US Core Condition Profile'
    # description ''

    id :condition_validation_test

    def resource_type
      'Condition'
    end

    def scratch_resources
      scratch[:condition_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition')
    end
  end
end
