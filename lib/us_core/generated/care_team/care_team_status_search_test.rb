require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class CareTeamStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for CareTeam search by status'
    description %(
      A server MAY support searching by status on the CareTeam resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :care_team_status_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'CareTeam',
        search_param_names: ['status']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:care_team_resources] ||= []
    end

    run do
      run_search_test
    end
  end
end
