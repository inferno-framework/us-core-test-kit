require_relative '../../validation_test'

module USCore
  class MedicationRequestValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'MedicationRequest resources returned during previous tests conform to the US Core MedicationRequest Profile'
    description %(
This test verifies resources returned from the first search conform to
the [US Core MedicationRequest Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest).

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

    )

    id :us_core_311_medication_request_validation_test

    def resource_type
      'MedicationRequest'
    end

    def scratch_resources
      scratch[:medication_request_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest')
    end
  end
end
