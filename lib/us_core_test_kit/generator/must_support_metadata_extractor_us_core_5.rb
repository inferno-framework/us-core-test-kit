require_relative 'must_support_metadata_extractor_us_core_4'

module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore5
      def self.handle_special_cases(profile, must_supports)
        return unless profile.version == '5.0.1'

        add_must_support_choices(profile, must_supports)
        add_patient_uscdi_elements(profile, must_supports)
        add_document_reference_category_values(profile, must_supports)
        remove_survey_questionnaire_response(profile, must_supports)
      end

      def self.add_must_support_choices(profile, must_supports)
        MustSupportMetadataExtractorUsCore4::add_must_support_choices(profile, must_supports)

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

      def self.add_patient_uscdi_elements(profile, must_supports)
        return unless profile.type == 'Patient'

        MustSupportMetadataExtractorUsCore4::add_patient_uscdi_elements(profile, must_supports)

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

      def self.add_document_reference_category_values(profile, must_supports)
        return unless profile.type == 'DocumentReference'

        slice = must_supports[:slices].find{|slice| slice[:path] == 'category'}

        slice[:discriminator][:values] = ['clinical-note'] if slice.present?
      end

      # FHIR-37794 Server systems are not required to support US Core QuestionnaireResponse
      def self.remove_survey_questionnaire_response(profile, must_supports)
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