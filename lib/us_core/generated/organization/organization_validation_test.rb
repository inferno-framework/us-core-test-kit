require_relative '../../validation_test'

module USCore
  class OrganizationValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Organization resources returned during previous tests conform to the US Core Organization Profile'
    description %(
This test verifies resources returned from the first search conform to
the [US Core Organization Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization).

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

    )

    id :organization_validation_test

    def resource_type
      'Organization'
    end

    def scratch_resources
      scratch[:organization_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization')
    end
  end
end
