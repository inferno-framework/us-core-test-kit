require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module USCoreTestKit
  module USCoreV400
    class CareTeamReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      include ResourceList

      title 'MustSupport references within CareTeam resources can be read'
      description %(
        This test will attempt to read MustSupport references found in the
        resources from the first search. This test will look through the CareTeam resources
        found previously for the following must support elements:

        * CareTeam.participant.member
      * CareTeam.subject
      )

      id :us_core_v400_care_team_reference_resolution_test

      def resource_type
        'CareTeam'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:care_team_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
