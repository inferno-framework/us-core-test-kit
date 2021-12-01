require_relative '../../validation_test'

module USCore
  class BodyweightValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the Observation Body Weight Profile'
    # description ''

    id :bodyweight_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:bodyweight_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/StructureDefinition/bodyweight')
    end
  end
end
