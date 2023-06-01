require_relative '../../../validation_test'

module USCoreTestKit
  module USCoreV600
    class ServiceRequestValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest

      id :us_core_v600_service_request_validation_test
      title 'ServiceRequest resources returned during previous tests conform to the US Core ServiceRequest Profile'
      description %(
This test verifies resources returned from the first search conform to
the [US Core ServiceRequest Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-servicerequest).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'ServiceRequest'
      end

      def scratch_resources
        scratch[:service_request_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-servicerequest',
                                '6.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
