require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV900
    class FamilyMemberHistoryPatientSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest
      id :us_core_v900_family_member_history_patient_search_test
      verifies_requirements 'hl7.fhir.us.core_9.0.0@51',
                            'hl7.fhir.us.core_9.0.0@52',
                            'hl7.fhir.us.core_9.0.0@58',
                            'hl7.fhir.us.core_9.0.0@1005'
      title 'Server returns valid results for FamilyMemberHistory search by patient'
      input :patient_ids, title: 'Patient IDs', description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'

      def self.properties
        @properties ||= SearchTestProperties.new(first_search: true, resource_type: 'FamilyMemberHistory', search_param_names: ['patient'], saves_delayed_references: true, test_reference_variants: true, test_post_search: true)
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:family_member_history_resources] ||= {}
      end

      run { run_search_test }
    end
  end
end
