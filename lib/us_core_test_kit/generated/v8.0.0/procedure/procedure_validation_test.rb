require_relative '../../../validation_test'

module USCoreTestKit
  module USCoreV800
    class ProcedureValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest

      id :us_core_v800_procedure_validation_test
      title 'Procedure resources returned during previous tests conform to the US Core Procedure Profile'
      description %(
This test verifies resources returned from the first search conform to
the [US Core Procedure Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      verifies_requirements 'hl7.fhir.us.core_8.0.0@18',
                            'hl7.fhir.us.core_8.0.0@19',
                            'hl7.fhir.us.core_8.0.0@20',
                            'hl7.fhir.us.core_8.0.0@21',
                            'hl7.fhir.us.core_8.0.0@23',
                            'hl7.fhir.us.core_8.0.0@27',
                            'hl7.fhir.us.core_8.0.0@40',
                            'hl7.fhir.us.core_8.0.0@74',
                            'hl7.fhir.us.core_8.0.0@486',
                            'hl7.fhir.us.core_8.0.0@856'
      output :dar_code_found, :dar_extension_found

      def resource_type
        'Procedure'
      end

      def scratch_resources
        scratch[:procedure_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure',
                                '8.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
