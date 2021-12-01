require_relative '../../validation_test'

module USCore
  class SmokingstatusValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the US Core Smoking Status Observation Profile'
    # description ''

    id :smokingstatus_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:smokingstatus_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus')
    end
  end
end
