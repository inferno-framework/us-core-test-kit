require_relative '../../../validation_test'

module USCoreTestKit
  module USCoreV700
    class QuestionnaireResponseValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest

      id :us_core_v700_questionnaire_response_validation_test
      title 'QuestionnaireResponse resources returned during previous tests conform to the US Core QuestionnaireResponse Profile'
      description %(
This test verifies resources returned from the first search conform to
the [US Core QuestionnaireResponse Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-questionnaireresponse).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'QuestionnaireResponse'
      end

      def scratch_resources
        scratch[:questionnaire_response_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-questionnaireresponse',
                                '7.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
