require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV700_BALLOT
    class CareTeamPatientRoleSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for CareTeam search by patient + role'
      description %(
A server SHOULD support searching by
patient + role on the CareTeam resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :us_core_v700_ballot_care_team_patient_role_search_test
      optional
  
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'CareTeam',
        search_param_names: ['patient', 'role'],
        possible_status_search: true,
        token_search_params: ['role']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:care_team_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
