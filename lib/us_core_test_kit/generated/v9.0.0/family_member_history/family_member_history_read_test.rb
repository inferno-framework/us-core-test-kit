require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV900
    class FamilyMemberHistoryReadTest < Inferno::Test
      include USCoreTestKit::ReadTest
      id :us_core_v900_family_member_history_read_test
      verifies_requirements 'hl7.fhir.us.core_9.0.0@1004'
      title 'Server returns correct FamilyMemberHistory resource from FamilyMemberHistory read interaction'

      def resource_type
        'FamilyMemberHistory'
      end

      def scratch_resources
        scratch[:family_member_history_resources] ||= {}
      end

      run { perform_read_test(all_scratch_resources) }
    end
  end
end
