require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV900
    class FamilyMemberHistoryMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest
      id :us_core_v900_family_member_history_must_support_test
      verifies_requirements 'hl7.fhir.us.core_9.0.0@1',
                            'hl7.fhir.us.core_9.0.0@13',
                            'hl7.fhir.us.core_9.0.0@75',
                            'hl7.fhir.us.core_9.0.0@84'
      title 'All must support elements are provided in the FamilyMemberHistory resources returned'
      description %(
        This test verifies that returned FamilyMemberHistory resources include status,
        patient, relationship, condition, and condition.code. The recorder extension
        is an Additional USCDI requirement and is checked as Must Support, consistent
        with the test kit's other profile tests. Present recorder references are also
        checked by the reference-resolution test.
      )

      def resource_type
        'FamilyMemberHistory'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:family_member_history_resources] ||= {}
      end

      run { perform_must_support_test(all_scratch_resources) }
    end
  end
end
