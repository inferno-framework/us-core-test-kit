require_relative '../../validation_test'

module USCore
  class OrganizationValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Organization resources returned during previous tests conform to the US Core Organization Profile'
    # description ''

    id :organization_validation_test

    def resource_type
      'Organization'
    end

    def scratch_resources
      scratch[:organization_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization')
    end
  end
end
