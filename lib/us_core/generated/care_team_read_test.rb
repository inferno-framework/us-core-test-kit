require_relative '../../read_test'

module USCore
  class CareTeamReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct CareTeam resource from CareTeam read interaction'
    description 'A server SHALL support the CareTeam read interaction.'

    id :care_team_read_test

    def resource_type
      'CareTeam'
    end

    run do
      perform_read_test(scratch[:care_team_resources])
    end
  end
end
