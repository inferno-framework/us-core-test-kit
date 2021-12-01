require_relative '../../validation_test'

module USCore
  class PractitionerValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Practitioner resources returned during previous tests conform to the US Core Practitioner Profile'
    # description ''

    id :practitioner_validation_test

    def resource_type
      'Practitioner'
    end

    def scratch_resources
      scratch[:practitioner_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner')
    end
  end
end
