require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV700
    class DocumentReferenceMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the DocumentReference resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the DocumentReference resources
        found previously for the following must support elements:

        * DocumentReference.author
        * DocumentReference.category
        * DocumentReference.content
        * DocumentReference.content.attachment
        * DocumentReference.content.attachment.contentType
        * DocumentReference.content.attachment.data or DocumentReference.content.attachment.url
        * DocumentReference.content.format
        * DocumentReference.context
        * DocumentReference.context.encounter
        * DocumentReference.context.period
        * DocumentReference.date
        * DocumentReference.identifier
        * DocumentReference.status
        * DocumentReference.subject
        * DocumentReference.type

        For ONC USCDI requirements, each DocumentReference must support the following additional elements:

        * DocumentReference.category:uscore
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@1', 'hl7.fhir.us.core_7.0.0@13', 'hl7.fhir.us.core_7.0.0@75', 'hl7.fhir.us.core_7.0.0@87', 'hl7.fhir.us.core_7.0.0@88', 'hl7.fhir.us.core_7.0.0@90', 'hl7.fhir.us.core_7.0.0@91', 'hl7.fhir.us.core_7.0.0@111', 'hl7.fhir.us.core_7.0.0@115', 'hl7.fhir.us.core_7.0.0@368'

      id :us_core_v700_document_reference_must_support_test

      def resource_type
        'DocumentReference'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:document_reference_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
