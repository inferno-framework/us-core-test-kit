require_relative 'must_support_metadata_extractor_us_core_5'

module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore6
      def self.handle_special_cases(profile, must_supports)
        return unless profile.version == '6.0.0-ballot'

        add_must_support_choices(profile, must_supports)
        add_patient_uscdi_elements(profile, must_supports)
        add_medicationrequest_uscdi_elements(profile, must_supports)
      end

      def self.add_must_support_choices(profile, must_supports)
        MustSupportMetadataExtractorUsCore5::add_must_support_choices(profile, must_supports)

        choices = []

        case profile.type
        when 'MedicationRequest'
          choices << { paths: ['reasonCode', 'reasonReference'] }
        end

        must_supports[:choices] = choices if choices.present?
      end

      def self.add_patient_uscdi_elements(profile, must_supports)
        return unless profile.type == 'Patient'

        MustSupportMetadataExtractorUsCore5::add_patient_uscdi_elements(profile, must_supports)

        must_supports[:extensions] << {
          id: 'Patient.extension:tribalAffiliation',
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-tribal-affiliation',
          uscdi_only: true
        }
        must_supports[:extensions] << {
          id: 'Patient.extension:sex-for-clinical-use',
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex-for-clinical-use',
          uscdi_only: true
        }
        must_supports[:elements] << {
          path: 'deceasedDateTime',
          uscdi_only: true
        }
      end

      def self.add_medicationrequest_uscdi_elements(profile, must_supports)
        return unless profile.type == 'MedicationRequest'

        must_supports[:elements] << {
          path: 'reasonCode',
          uscdi_only: true
        }
        must_supports[:elements] << {
          path: 'reasonReferene',
          uscdi_only: true
        }
      end
    end
  end
end