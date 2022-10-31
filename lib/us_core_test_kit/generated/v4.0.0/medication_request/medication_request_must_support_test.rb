require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV400
    class MedicationRequestMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the MedicationRequest resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the MedicationRequest resources
        found previously for the following must support elements:

        * MedicationRequest.authoredOn
        * MedicationRequest.category
        * MedicationRequest.dosageInstruction
        * MedicationRequest.dosageInstruction.text
        * MedicationRequest.encounter
        * MedicationRequest.intent
        * MedicationRequest.medication[x]
        * MedicationRequest.reportedBoolean or MedicationRequest.reportedReference
        * MedicationRequest.requester
        * MedicationRequest.status
        * MedicationRequest.subject
      )

      id :us_core_v400_medication_request_must_support_test

      def resource_type
        'MedicationRequest'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_request_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
