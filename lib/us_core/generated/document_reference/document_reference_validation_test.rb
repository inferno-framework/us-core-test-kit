require_relative '../../validation_test'

module USCore
  class DocumentReferenceValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'DocumentReference resources returned during previous tests conform to the US Core DocumentReference Profile'
    # description ''

    id :document_reference_validation_test

    def resource_type
      'DocumentReference'
    end

    def scratch_resources
      scratch[:document_reference_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference')
    end
  end
end
