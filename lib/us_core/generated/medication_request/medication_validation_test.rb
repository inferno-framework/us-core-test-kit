require_relative '../../validation_test'

module USCore
  class MedicationValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Medication resources returned during previous tests conform to the US Core Medication Profile'
    description %(
This test verifies resources returned from previous tests conform to
the [US Core Medication Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication).

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

    )

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
