require_relative 'care_team/care_team_patient_search_test'
require_relative 'care_team/care_team_status_search_test'
require_relative 'care_team/care_team_patient_status_search_test'
require_relative 'care_team/care_team_read_test'

module USCore
  class CareTeamGroup < Inferno::TestGroup
    title 'CareTeam Tests'
    # description ''

    id :care_team

    test from: :care_team_patient_search_test
    test from: :care_team_status_search_test
    test from: :care_team_patient_status_search_test
    test from: :care_team_read_test
  end
end
