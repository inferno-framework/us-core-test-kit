require_relative 'must_support_metadata_extractor_us_core_5'

module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore6
      attr_accessor :profile, :must_supports

      def initialize(profile, must_supports)
        self.profile = profile
        self.must_supports = must_supports
      end

      def us_core_5_extractor
        @us_core_5_extractor ||= MustSupportMetadataExtractorUsCore5.new(profile, must_supports)
      end

      def handle_special_cases
        add_must_support_choices
        add_uscdi_elements
        add_value_set_expansion
      end

      def add_must_support_choices
        us_core_5_extractor.add_must_support_choices

        more_choices = []

        case profile.type
        when 'MedicationRequest'
          more_choices << {
            paths: ['reasonCode', 'reasonReference'],
            uscdi_only: true
          }
        end

        if more_choices.present?
          must_supports[:choices] ||= []
          must_supports[:choices].concat(more_choices)
        end
      end

      def add_uscdi_elements
        add_patient_uscdi_elements
        add_medicationrequest_uscdi_elements
      end

      def add_patient_uscdi_elements
        return unless profile.type == 'Patient'

        us_core_5_extractor.add_patient_uscdi_elements

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

      def add_medicationrequest_uscdi_elements
        return unless profile.type == 'MedicationRequest'

        must_supports[:elements] << {
          path: 'reasonCode',
          uscdi_only: true
        }
        must_supports[:elements] << {
          path: 'reasonReference',
          types: [ 'Reference' ],
          uscdi_only: true
        }
      end

      def add_value_set_expansion
        us_core_5_extractor.add_value_set_expansion
      end
    end
  end
end