require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV700
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
        * MedicationRequest.category:us-core
        * MedicationRequest.dispenseRequest
        * MedicationRequest.dispenseRequest.numberOfRepeatsAllowed
        * MedicationRequest.dispenseRequest.quantity
        * MedicationRequest.dosageInstruction
        * MedicationRequest.dosageInstruction.doseAndRate
        * MedicationRequest.dosageInstruction.doseAndRate.doseQuantity
        * MedicationRequest.dosageInstruction.text
        * MedicationRequest.dosageInstruction.timing
        * MedicationRequest.encounter
        * MedicationRequest.intent
        * MedicationRequest.medication[x]
        * MedicationRequest.reportedBoolean or MedicationRequest.reportedReference
        * MedicationRequest.requester
        * MedicationRequest.status
        * MedicationRequest.subject

        For ONC USCDI requirements, each MedicationRequest must support the following additional elements:

        * MedicationRequest.extension:medicationAdherence
        * MedicationRequest.reasonCode or MedicationRequest.reasonReference
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@1',
                            'hl7.fhir.us.core_7.0.0@13',
                            'hl7.fhir.us.core_7.0.0@75',
                            'hl7.fhir.us.core_7.0.0@87',
                            'hl7.fhir.us.core_7.0.0@90',
                            'hl7.fhir.us.core_7.0.0@91',
                            'hl7.fhir.us.core_7.0.0@93',
                            'hl7.fhir.us.core_7.0.0@94',
                            'hl7.fhir.us.core_7.0.0@97',
                            'hl7.fhir.us.core_7.0.0@99',
                            'hl7.fhir.us.core_7.0.0@111',
                            'hl7.fhir.us.core_7.0.0@115',
                            'hl7.fhir.us.core_7.0.0@405',
                            'hl7.fhir.us.core_7.0.0@408',
                            'hl7.fhir.us.core_7.0.0@406',
                            'hl7.fhir.us.core_7.0.0@411'

      id :us_core_v700_medication_request_must_support_test

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
