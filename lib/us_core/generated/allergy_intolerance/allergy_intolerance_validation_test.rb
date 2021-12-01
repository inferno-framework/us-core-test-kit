require_relative '../../validation_test'

module USCore
  class AllergyIntoleranceValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'AllergyIntolerance resources returned during previous tests conform to the US  Core AllergyIntolerance Profile'
    # description ''

    id :allergy_intolerance_validation_test

    def resource_type
      'AllergyIntolerance'
    end

    def scratch_resources
      scratch[:allergy_intolerance_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance')
    end
  end
end
