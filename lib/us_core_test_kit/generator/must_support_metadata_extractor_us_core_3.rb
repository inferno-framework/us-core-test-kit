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
        remove_patient_address_period
        remove_document_reference_custodian
      end

      def add_must_support_choices
        more_choices = []

        case profile.type
        when 'Device'
          more_choices << { paths: ['udiCarrier.carrierAIDC', 'udiCarrier.carrierHRF'] }
        end

        if more_choices.present?
          must_supports[:choices] ||= []
          must_supports[:choices].concat(more_choices)
        end
      end

      # FHIR-40299 removes Patient.address.period from MustSupport,
      def remove_patient_address_period
        return unless profile.type == 'Patient'

        must_supports[:elements].delete_if do |element|
          element[:path] == 'address.period'
        end
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