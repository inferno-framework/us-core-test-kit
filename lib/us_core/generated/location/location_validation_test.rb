require_relative '../../validation_test'

module USCore
  class LocationValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Location resources returned during previous tests conform to the US Core Location Profile'
    # description ''

    id :location_validation_test

    def resource_type
      'Location'
    end

    def scratch_resources
      scratch[:location_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-location')
    end
  end
end
