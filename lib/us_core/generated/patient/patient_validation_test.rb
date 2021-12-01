require_relative '../../validation_test'

module USCore
  class PatientValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Patient resources returned during previous tests conform to the US Core Patient Profile'
    # description ''

    id :patient_validation_test

    def resource_type
      'Patient'
    end

    def scratch_resources
      scratch[:patient_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient')
    end
  end
end
