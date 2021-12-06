require_relative '../../validation_test'

module USCore
  class BodyheightValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the Observation Body Height Profile'
    description %(
This test verifies resources returned from the first search conform to
the [Observation Body Height Profile](http://hl7.org/fhir/StructureDefinition/bodyheight).

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

    )

    id :us_core_311_bodyheight_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:bodyheight_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/StructureDefinition/bodyheight')
    end
  end
end
