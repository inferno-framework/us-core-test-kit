require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV800_BALLOT
    class CareTeamReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct CareTeam resource from CareTeam read interaction'
      description 'A server SHALL support the CareTeam read interaction.'

      id :us_core_v800_ballot_care_team_read_test

      def resource_type
        'CareTeam'
      end

      def scratch_resources
        scratch[:care_team_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
