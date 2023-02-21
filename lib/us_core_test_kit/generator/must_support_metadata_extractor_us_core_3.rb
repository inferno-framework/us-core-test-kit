module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore3
      attr_accessor :profile, :must_supports

      def initialize(profile, must_supports)
        self.profile = profile
        self.must_supports = must_supports
      end

      def handle_special_cases
        add_must_support_choices
        remove_document_reference_custodian
      end

      def add_must_support_choices
        choices = []

        case profile.type
        when 'Device'
          choices << { paths: ['udiCarrier.carrierAIDC', 'udiCarrier.carrierHRF'] }
        when 'DocumentReference'
          choices << { paths: ['content.attachment.data', 'content.attachment.url'] }
        end

        must_supports[:choices] = choices if choices.present?
      end

      # US Core clarified that server implmentation is not required to support DocumentReference.custodian (FHIR-28393)
      def remove_document_reference_custodian
        return unless profile.type == 'DocumentReference'

        must_supports[:elements].delete_if do |element|
          element[:path] == 'custodian'
        end
      end
    end
  end
end