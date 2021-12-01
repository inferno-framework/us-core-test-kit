require_relative '../../validation_test'

module USCore
  class PulseOximetryValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the US Core Pulse Oximetry Profile'
    # description ''

    id :pulse_oximetry_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:pulse_oximetry_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry')
    end
  end
end
