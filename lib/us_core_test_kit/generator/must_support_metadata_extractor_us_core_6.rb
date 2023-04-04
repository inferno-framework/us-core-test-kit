require_relative 'must_support_metadata_extractor_us_core_5'

module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore6
      attr_accessor :profile, :must_supports

      US_CORE_CATEGORY = ['sdoh', 'functional-status', 'disability-status', 'cognitive-status']

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
        # TODO: US Core 6.0.0-ballot version has a bug in Observation Occupation Profile.
        # Slicing on Observation.component:industry is not correct. See HL7 JIRA FHIR-39608
        # This is a temparory fix. This method SHALL be removed after US Core 6.0.0 release
        replace_occupation_industry
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
        add_procedure_uscdi_elements
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

      def add_procedure_uscdi_elements
        return unless profile.type == 'Procedure'

        must_supports[:elements] << {
          path: 'basedOn',
          types: ['Reference'],
          uscdi_only: true
        }
      end

      def replace_occupation_industry
        # TODO: US Core 6.0.0-ballot version has a bug in Observation Occupation Profile.
        # Slicing on Observation.component:industry is not correct. See HL7 JIRA FHIR-39608
        # This is a temparory fix. This method SHALL be removed after US Core 6.0.0 release

        return unless profile.url == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-occupation'

        must_supports[:slices].delete_if { |slice| slice[:name].include?('Observation.component:industry') }

        must_supports[:slices] << {
          name: 'Observation.component:industry',
          path: 'component.code',
          discriminator: {
            type: 'patternCodeableConcept',
            path: '',
            code: '86188-0',
            system: 'http://loinc.org'
          }
        }
      end
    end
  end
end