require_relative '../../../validation_test'

module USCoreTestKit
  module USCoreV501
    class MedicationValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest

      id :us_core_v501_medication_validation_test
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
      output :dar_code_found, :dar_extension_found

      def resource_type
        'Medication'
      end

      def scratch_resources
        scratch[:medication_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication',
                                '5.0.1',
                                skip_if_empty: false)
      end
    end
  end
end
