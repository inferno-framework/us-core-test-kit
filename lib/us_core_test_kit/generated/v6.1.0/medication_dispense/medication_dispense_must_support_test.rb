require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV610
    class MedicationDispenseMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the MedicationDispense resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the MedicationDispense resources
        found previously for the following must support elements:

        * MedicationDispense.authorizingPrescription
        * MedicationDispense.dosageInstruction
        * MedicationDispense.dosageInstruction.doseAndRate
        * MedicationDispense.dosageInstruction.doseAndRate.doseQuantity
        * MedicationDispense.dosageInstruction.text
        * MedicationDispense.dosageInstruction.timing
        * MedicationDispense.medication[x]
        * MedicationDispense.performer
        * MedicationDispense.performer.actor
        * MedicationDispense.quantity
        * MedicationDispense.status
        * MedicationDispense.subject
        * MedicationDispense.type
        * MedicationDispense.whenHandedOver
      )

      id :us_core_v610_medication_dispense_must_support_test

      def resource_type
        'MedicationDispense'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_dispense_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
