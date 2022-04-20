require_relative '../../../validation_test'

module USCoreTestKit
  module USCoreV311
    class BpValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest

      id :us_core_v311_bp_validation_test
      title 'Observation resources returned during previous tests conform to the Observation Blood Pressure Profile'
      description %(
This test verifies resources returned from the first search conform to
the [Observation Blood Pressure Profile](http://hl7.org/fhir/StructureDefinition/bp).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'Observation'
      end

      def scratch_resources
        scratch[:bp_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/StructureDefinition/bp',
                                must_demonstrate_resource_type: true)
      end
    end
  end
end
