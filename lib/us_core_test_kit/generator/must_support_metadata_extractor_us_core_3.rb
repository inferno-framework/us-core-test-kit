module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore3

      def self.handle_special_cases(profile, must_supports)
        return unless profile.version == '3.1.1'

        add_must_support_choices(profile, must_supports)
        remove_document_reference_custodian(profile, must_supports)
      end

      def self.add_must_support_choices(profile, must_supports)
        choices = []

        choices << { paths: ['content.attachment.data', 'content.attachment.url'] } if profile.type == 'DocumentReference'
        choices << { paths: ['udiCarrier.carrierAIDC', 'udiCarrier.carrierHRF'] } if profile.type == 'Device'

        must_supports[:choices] = choices if choices.present?
      end

      # US Core clarified that server implmentation is not required to support DocumentReference.custodian (FHIR-28393)
      def self.remove_document_reference_custodian(profile, must_supports)
        if profile.type == 'DocumentReference'
          must_supports[:elements].delete_if do |element|
            element[:path] == 'custodian'
          end
        end
      end
    end
  end
end