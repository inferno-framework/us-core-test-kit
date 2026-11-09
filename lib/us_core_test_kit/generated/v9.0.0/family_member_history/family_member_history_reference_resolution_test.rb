require_relative '../../../reference_resolution_test'

module USCoreTestKit
  module USCoreV900
    class FamilyMemberHistoryReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      id :us_core_v900_family_member_history_reference_resolution_test
      verifies_requirements 'hl7.fhir.us.core_9.0.0@105',
                            'hl7.fhir.us.core_9.0.0@109',
                            'hl7.fhir.us.core_9.0.0@808',
                            'hl7.fhir.us.core_9.0.0@809',
                            'hl7.fhir.us.core_9.0.0@810',
                            'hl7.fhir.us.core_9.0.0@811',
                            'hl7.fhir.us.core_9.0.0@881',
                            'hl7.fhir.us.core_9.0.0@883'
      title 'Must Support references within FamilyMemberHistory resources are valid'

      def resource_type
        'FamilyMemberHistory'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:family_member_history_resources] ||= {}
      end

      run { perform_reference_resolution_test(scratch_resources[:all]) }
    end
  end
end
