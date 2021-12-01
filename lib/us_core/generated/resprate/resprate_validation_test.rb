require_relative '../../validation_test'

module USCore
  class ResprateValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the Observation Respiratory Rate Profile'
    # description ''

    id :resprate_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:resprate_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/StructureDefinition/resprate')
    end
  end
end
