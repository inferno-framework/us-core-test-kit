require_relative '../../validation_test'

module USCore
  class ProvenanceValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Provenance resources returned during previous tests conform to the US Core Provenance Profile'
    # description ''

    id :provenance_validation_test

    def resource_type
      'Provenance'
    end

    def scratch_resources
      scratch[:provenance_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance')
    end
  end
end
