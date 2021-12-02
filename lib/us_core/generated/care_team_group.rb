require_relative 'care_team/care_team_patient_status_search_test'
require_relative 'care_team/care_team_read_test'
require_relative 'care_team/care_team_provenance_revinclude_search_test'
require_relative 'care_team/care_team_validation_test'
require_relative 'care_team/care_team_must_support_test'
require_relative 'care_team/care_team_reference_resolution_test'

module USCore
  class CareTeamGroup < Inferno::TestGroup
    title 'CareTeam Tests'
    # description ''

    id :care_team

    test from: :care_team_patient_status_search_test
    test from: :care_team_read_test
    test from: :care_team_provenance_revinclude_search_test
    test from: :care_team_validation_test
    test from: :care_team_must_support_test
    test from: :care_team_reference_resolution_test
  end
end
