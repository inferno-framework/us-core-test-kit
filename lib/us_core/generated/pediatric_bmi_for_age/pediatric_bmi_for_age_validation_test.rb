require_relative '../../validation_test'

module USCore
  class PediatricBmiForAgeValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Observation resources returned during previous tests conform to the US Core Pediatric BMI for Age Observation Profile'
    # description ''

    id :pediatric_bmi_for_age_validation_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:pediatric_bmi_for_age_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age')
    end
  end
end
