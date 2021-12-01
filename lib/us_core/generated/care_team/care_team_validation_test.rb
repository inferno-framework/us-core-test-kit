require_relative '../../validation_test'

module USCore
  class CareTeamValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'CareTeam resources returned during previous tests conform to the US Core CareTeam Profile'
    # description ''

    id :care_team_validation_test

    def resource_type
      'CareTeam'
    end

    def scratch_resources
      scratch[:care_team_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam')
    end
  end
end
