require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV800
    class AdiDocumentReferenceMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the DocumentReference resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the DocumentReference resources
        found previously for the following must support elements:

        * DocumentReference.authenticator
        * DocumentReference.author
        * DocumentReference.category
        * DocumentReference.category:adi
        * DocumentReference.content
        * DocumentReference.content.attachment
        * DocumentReference.content.attachment.contentType
        * DocumentReference.content.attachment.data or DocumentReference.content.attachment.url
        * DocumentReference.content.format
        * DocumentReference.date
        * DocumentReference.extension:authenticationTime
        * DocumentReference.identifier
        * DocumentReference.status
        * DocumentReference.subject
        * DocumentReference.type
      )
      verifies_requirements 'hl7.fhir.us.core_8.0.0@1', 'hl7.fhir.us.core_8.0.0@13', 'hl7.fhir.us.core_8.0.0@75', 'hl7.fhir.us.core_8.0.0@87', 'hl7.fhir.us.core_8.0.0@88', 'hl7.fhir.us.core_8.0.0@90', 'hl7.fhir.us.core_8.0.0@91', 'hl7.fhir.us.core_8.0.0@111', 'hl7.fhir.us.core_8.0.0@115'

      id :us_core_v800_adi_document_reference_must_support_test

      def resource_type
        'DocumentReference'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:adi_document_reference_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
