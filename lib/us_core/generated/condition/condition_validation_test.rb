require_relative '../../validation_test'

module USCore
  class ConditionValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Condition resources returned during previous tests conform to the US Core Condition Profile'
    description %(
This test verifies resources returned from the first search conform to
the [US Core Condition Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition).

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

    )

    id :condition_validation_test

    def resource_type
      'Condition'
    end

    def scratch_resources
      scratch[:condition_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition')
    end
  end
end
