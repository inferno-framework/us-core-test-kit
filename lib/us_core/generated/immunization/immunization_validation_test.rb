require_relative '../../validation_test'

module USCore
  class ImmunizationValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Immunization resources returned during previous tests conform to the US Core Immunization Profile'
    # description ''

    id :immunization_validation_test

    def resource_type
      'Immunization'
    end

    def scratch_resources
      scratch[:immunization_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization')
    end
  end
end
