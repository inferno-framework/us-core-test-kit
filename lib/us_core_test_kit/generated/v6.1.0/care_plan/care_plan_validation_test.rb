require_relative '../../../validation_test'

module USCoreTestKit
  module USCoreV610
    class CarePlanValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest

      id :us_core_v610_care_plan_validation_test
      title 'CarePlan resources returned during previous tests conform to the US Core CarePlan Profile'
      description %(
This test verifies resources returned from the first search conform to
the [US Core CarePlan Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      verifies_requirements 'hl7.fhir.us.core_6.1.0@18',
                            'hl7.fhir.us.core_6.1.0@19',
                            'hl7.fhir.us.core_6.1.0@20',
                            'hl7.fhir.us.core_6.1.0@21',
                            'hl7.fhir.us.core_6.1.0@23',
                            'hl7.fhir.us.core_6.1.0@27',
                            'hl7.fhir.us.core_6.1.0@40',
                            'hl7.fhir.us.core_6.1.0@74'
      output :dar_code_found, :dar_extension_found

      def resource_type
        'CarePlan'
      end

      def scratch_resources
        scratch[:care_plan_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
