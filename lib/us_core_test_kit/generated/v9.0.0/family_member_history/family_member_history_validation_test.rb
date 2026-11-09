require_relative '../../../validation_test'

module USCoreTestKit
  module USCoreV900
    class FamilyMemberHistoryValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest
      id :us_core_v900_family_member_history_validation_test
      verifies_requirements 'hl7.fhir.us.core_9.0.0@18',
                            'hl7.fhir.us.core_9.0.0@19',
                            'hl7.fhir.us.core_9.0.0@20',
                            'hl7.fhir.us.core_9.0.0@21',
                            'hl7.fhir.us.core_9.0.0@23',
                            'hl7.fhir.us.core_9.0.0@27',
                            'hl7.fhir.us.core_9.0.0@40'
      title 'FamilyMemberHistory resources returned during previous tests conform to the US Core FamilyMemberHistory Profile'

      def resource_type
        'FamilyMemberHistory'
      end

      def scratch_resources
        scratch[:family_member_history_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-familymemberhistory',
                                '9.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
