require_relative '../../validation_test'

module USCore
  class HeartrateValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the Observation Heart Rate Profile'
    # description ''

    id :heartrate_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:heartrate_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/StructureDefinition/heartrate')
    end
  end
end
