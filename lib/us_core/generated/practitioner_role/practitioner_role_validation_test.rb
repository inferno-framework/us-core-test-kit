require_relative '../../validation_test'

module USCore
  class PractitionerRoleValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'PractitionerRole resources returned during previous tests conform to the US Core PractitionerRole Profile'
    # description ''

    id :practitioner_role_validation_test

    def resource_type
      'PractitionerRole'
    end

    def scratch_resources
      scratch[:practitioner_role_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole')
    end
  end
end
