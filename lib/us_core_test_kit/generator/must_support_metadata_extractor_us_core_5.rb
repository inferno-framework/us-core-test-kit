require_relative 'must_support_metadata_extractor_us_core_4'

module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore5
      attr_accessor :profile, :must_supports

      def initialize(profile, must_supports)
        self.profile = profile
        self.must_supports = must_supports
      end


      def us_core_4_extractor
        @us_core_4_extractor ||= MustSupportMetadataExtractorUsCore4.new(profile, must_supports)
      end

      def handle_special_cases
        add_must_support_choices
        add_patient_uscdi_elements
        add_document_reference_category_values
        remove_survey_questionnaire_response
      end

      def add_must_support_choices
        us_core_4_extractor.add_must_support_choices

        choices = []

        case profile.type
        when 'CareTeam'
          choices << {
            target_profiles: [
              'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner',
              'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole'
            ]
          }
        when 'Condition'
          choices << {
            paths: ['onsetDateTime'],
            extension_ids: ['Condition.extension:assertedDate']
          }
        end

        must_supports[:choices] = choices if choices.present?
      end

      def add_patient_uscdi_elements
        return unless profile.type == 'Patient'

        us_core_4_extractor.add_patient_uscdi_elements

        must_supports[:extensions] << {
          id: 'Patient.extension:genderIdentity',
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-genderIdentity',
          uscdi_only: true
        }
        must_supports[:elements] << {
          path: 'address.use',
          fixed_value: 'old',
          uscdi_only: true
        }
        must_supports[:elements] << {
          path: 'name.use',
          fixed_value: 'old',
          uscdi_only: true
        }
      end

      def add_document_reference_category_values
        return unless profile.type == 'DocumentReference'

        slice = must_supports[:slices].find{|slice| slice[:path] == 'category'}

        slice[:discriminator][:values] = ['clinical-note'] if slice.present?
      end

      # FHIR-37794 Server systems are not required to support US Core QuestionnaireResponse
      def remove_survey_questionnaire_response
        return unless profile.type == 'Observation' &&
          ['us-core-observation-survey', 'us-core-observation-sdoh-assessment'].include?(profile.id)

        element = must_supports[:elements].find { |element| element[:path] == 'derivedFrom' }
        element[:target_profiles].delete_if do |url|
          url == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-questionnaireresponse'
        end
      end
    end
  end
end