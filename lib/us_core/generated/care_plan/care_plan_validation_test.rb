require_relative '../../validation_test'

module USCore
  class CarePlanValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'CarePlan resources returned during previous tests conform to the US Core CarePlan Profile'
    # description ''

    id :care_plan_validation_test

    def resource_type
      'CarePlan'
    end

    def scratch_resources
      scratch[:care_plan_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan')
    end
  end
end
