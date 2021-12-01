require_relative '../../validation_test'

module USCore
  class EncounterValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Encounter resources returned during previous tests conform to the US Core Encounter Profile'
    # description ''

    id :encounter_validation_test

    def resource_type
      'Encounter'
    end

    def scratch_resources
      scratch[:encounter_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter')
    end
  end
end
