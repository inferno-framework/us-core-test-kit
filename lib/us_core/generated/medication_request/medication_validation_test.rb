require_relative '../../validation_test'

module USCore
  class MedicationValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Medication resources returned during previous tests conform to the US Core Medication Profile'
    # description ''

    id :medication_validation_test

    def resource_type
      'Medication'
    end

    def scratch_resources
      scratch[:medication_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication')
    end
  end
end
