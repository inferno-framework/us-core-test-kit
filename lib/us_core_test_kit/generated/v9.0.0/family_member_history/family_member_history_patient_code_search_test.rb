require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV900
    class FamilyMemberHistoryPatientCodeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      id :us_core_v900_family_member_history_patient_code_search_test
      verifies_requirements 'hl7.fhir.us.core_9.0.0@55',
                            'hl7.fhir.us.core_9.0.0@1006'
      title 'Server supports the recommended FamilyMemberHistory search by patient and code'
      description %(
        US Core v9 recommends the patient + code search combination. This optional test
        uses condition codes from the FamilyMemberHistory resources already collected
        by patient and checks token-search results, including system-qualified codes.
      )
      optional
      input :patient_ids, title: 'Patient IDs'

      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'FamilyMemberHistory',
          search_param_names: ['patient', 'code'],
          token_search_params: ['code']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(
          YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)
        )
      end

      def scratch_resources
        scratch[:family_member_history_resources] ||= {}
      end

      run { run_search_test }
    end
  end
end
