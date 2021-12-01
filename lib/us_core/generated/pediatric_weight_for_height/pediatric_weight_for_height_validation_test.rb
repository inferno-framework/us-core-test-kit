require_relative '../../validation_test'

module USCore
  class PediatricWeightForHeightValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the US Core Pediatric Weight for Height Observation Profile'
    # description ''

    id :pediatric_weight_for_height_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:pediatric_weight_for_height_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height')
    end
  end
end
