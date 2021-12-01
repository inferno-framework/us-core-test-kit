require_relative '../../validation_test'

module USCore
  class BpValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the Observation Blood Pressure Profile'
    # description ''

    id :bp_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:bp_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/StructureDefinition/bp')
    end
  end
end
