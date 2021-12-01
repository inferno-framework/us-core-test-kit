require_relative '../../validation_test'

module USCore
  class ObservationLabValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the US Core Laboratory Result Observation Profile'
    # description ''

    id :observation_lab_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:observation_lab_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab')
    end
  end
end
