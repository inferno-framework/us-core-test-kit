require_relative '../../validation_test'

module USCore
  class ImmunizationValidationTest < Inferno::Test
    include USCore::ValidationTest

    id :us_core_311_immunization_validation_test
    title 'Immunization resources returned during previous tests conform to the US Core Immunization Profile'
    description %(
This test verifies resources returned from the first search conform to
the [US Core Immunization Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization).

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

    )
    output :dar_code_found, :dar_extension_found

    def resource_type
      'Immunization'
    end

    def scratch_resources
      scratch[:immunization_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization')
    end
  end
end
