require_relative '../../validation_test'

module USCore
  class BodytempValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the Observation Body Temperature Profile'
    # description ''

    id :bodytemp_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:bodytemp_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/StructureDefinition/bodytemp')
    end
  end
end
