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
        update_patient_previous_name_address
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

      # FHIR-40299 adds USCDI MustSupport choices for:
      # * address.period.end and address.use,
      # * name.period.end and name.use
      def update_patient_previous_name_address
        return unless profile.type == 'Patient'

        name_period_exists = false
        name_use_exists = false
        address_period_exists = false
        address_use_exists = false

        must_supports[:elements].each do |element|
          case element[:path]
          when 'name.period'
            element[:path] = 'name.period.end'
            element[:uscdi_only] = true
            name_period_exists = true
          when 'name.use'
            element[:fixed_value] = 'old'
            element[:uscdi_only] = true
            name_use_exists = true
          when 'address.period'
            element[:path] = 'address.period.end'
            element[:uscdi_only] = true
            address_period_exists = true
          when 'address.use'
            element[:fixed_value] = 'old'
            element[:uscdi_only] = true
            address_use_exists = true
          end
        end

        must_supports[:elements] << {
          path: 'name.period.end',
          uscdi_only: true
        } unless name_period_exists

        must_supports[:elements] << {
          path: 'name.use',
          fixed_value: 'old',
          uscdi_only: true
        } unless name_use_exists

        must_supports[:elements] << {
          path: 'address.period.end',
          uscdi_only: true
        } unless address_period_exists

        must_supports[:elements] << {
          path: 'address.use',
          fixed_value: 'old',
          uscdi_only: true
        } unless address_use_exists

        must_supports[:choices] ||= []

        must_supports[:choices] << {
          paths: ['address.period.end', 'address.use'],
          uscdi_only: true
        }

        must_supports[:choices] << {
          paths: ['name.period.end', 'name.use'],
          uscdi_only: true
        }

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