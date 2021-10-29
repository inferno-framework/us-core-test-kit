require_relative '../../search_test'

module USCore
  class CareTeamPatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for CareTeam search by patient'
    description %(
      A server MAY support searching by patient on the CareTeam resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :care_team_patient_search_test

    input :patient_id, default: '85'

    def resource_type
      'CareTeam'
    end

    def scratch_resources
      scratch[:care_team_resources] = [] if scratch[:care_team_resources].nil?
      scratch[:care_team_resources]
    end

    def search_params
      {
        'patient': patient_id
      }
    end

    run do
      perform_search_test
    end
  end
end
