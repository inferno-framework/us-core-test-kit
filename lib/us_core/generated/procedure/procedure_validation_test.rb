require_relative '../../validation_test'

module USCore
  class ProcedureValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Procedure resources returned during previous tests conform to the US Core Procedure Profile'
    # description ''

    id :procedure_validation_test

    def resource_type
      'Procedure'
    end

    def scratch_resources
      scratch[:procedure_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure')
    end
  end
end
