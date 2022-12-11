require_relative '../../../validation_test'

module USCoreTestKit
  module USCoreV600_BALLOT
    class ObservationPregnancyintentValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest

      id :us_core_v600_ballot_observation_pregnancyintent_validation_test
      title 'Observation resources returned during previous tests conform to the US Core Observation Pregnancy Intent Profile'
      description %(
This test verifies resources returned from the first search conform to
the [US Core Observation Pregnancy Intent Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-pregnancyintent).
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
        scratch[:observation_pregnancyintent_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-pregnancyintent',
                                '6.0.0-ballot',
                                skip_if_empty: true)
      end
    end
  end
end
