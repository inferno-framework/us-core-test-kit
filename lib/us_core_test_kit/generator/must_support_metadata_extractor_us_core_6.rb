module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore6
      attr_accessor :profile, :must_supports

      def initialize(profile, must_supports)
        self.profile = profile
        self.must_supports = must_supports
      end

      def us_core_3_extractor
        @us_core_3_extractor ||= MustSupportMetadataExtractorUsCore3.new(profile, must_supports)
      end

      def us_core_4_extractor
        @us_core_4_extractor ||= MustSupportMetadataExtractorUsCore4.new(profile, must_supports)
      end

      def us_core_5_extractor
        @us_core_5_extractor ||= MustSupportMetadataExtractorUsCore5.new(profile, must_supports)
      end

      def handle_special_cases
        add_must_support_choices
        add_patient_uscdi_elements
        update_smoking_status_effective
        remove_practitioner_address
        remove_diagnosticreport_media
        remove_patient_gender_identity
        remove_medicationdispense_practitioner
        remove_coverage_group_name
        remove_must_supports_from_encounter_diagnosis
      end

      def add_must_support_choices
        us_core_5_extractor.add_must_support_choices

        more_choices = []

        case profile.type
        when 'Goal'
          more_choices << {
            paths: ['startDate', 'target.dueDate']
          }
        when 'MedicationRequest'
          more_choices << {
            paths: ['reasonCode', 'reasonReference'],
            uscdi_only: true
          }
        when 'ServiceRequest'
          more_choices << {
            paths: ['reasonCode', 'reasonReference'],
            uscdi_only: true
          }
        end

        if profile.id == 'us-core-observation-screening-assessment'
          more_choices << {
            target_profiles: [
              'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-screening-assessment',
              'http://hl7.org/fhir/us/core/StructureDefinition/us-core-questionnaireresponse'
            ]
          }
        end

        if more_choices.present?
          must_supports[:choices] ||= []
          must_supports[:choices].concat(more_choices)
        end
      end

      def add_patient_uscdi_elements
        return unless profile.type == 'Patient'

        us_core_4_extractor.add_patient_telecom_communication_uscdi
        us_core_3_extractor.update_patient_previous_name_address

        must_supports[:elements].each do |element|
          case element[:path]
          when 'deceased[x]'
            element[:original_path] = element[:path]
            element[:path] = 'deceasedDateTime'
          end
        end
      end

      # US Core v6.1.0 Patch FHIR-43355, US Core Smoking Status Observation Profile may be supported
      # either Observation.effectiveDateTime or Observation.effectivePeriod data element
      def update_smoking_status_effective
        return unless profile.id == 'us-core-smokingstatus'

        must_supports[:slices].delete_if { |slice| slice[:slice_id] == 'Observation.effective[x]:effectiveDateTime' }
        must_supports[:elements] << { path: 'effective[x]' }
      end

      # US Core v6.1.0 Patch FHIR-44693, Add MustSupport choice between Practitioner.address and PractitionerRole
      # This is fixed formally in US Core v7
      def remove_practitioner_address
        return unless profile.type == 'Practitioner'

        must_supports[:elements].delete_if { |element| element[:path].start_with?('address') }
      end

      # US Core v6.1.0 Patch FHIR-46240, Remove the Must Support on media and media.link
      def remove_diagnosticreport_media
        return unless profile.id == 'us-core-diagnosticreport-note'
        must_supports[:elements].delete_if { |element| element[:path].start_with?('media') }
      end

      # genderIdentify is removed as directed by ASTP/ONC enforcement discretion issued on March 21, 2025:
      # https://www.healthit.gov/topic/certification-ehrs/enforcement-discretion
      def remove_patient_gender_identity
        return unless profile.type == 'Patient'
        must_supports[:extensions].delete_if { |extension| extension[:id] == 'Patient.extension:genderIdentity' }
      end

      # US Core v6.1.0 Patch FHIR-50239, Remove MustSupport target profile from MedicationDispense.performer.actor
      # - US Core Practitioner
      def remove_medicationdispense_practitioner
        return unless profile.type == 'MedicationDispense'

        element = must_supports[:elements].find { |element| element[:path] == 'performer.actor' }
        element[:target_profiles].delete_if do |url|
          url == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner'
        end
      end

      # US Core v6.1.0 Patch FHIR-50283, Remove MustSupport element from Coverage:
      # - group name
      def remove_coverage_group_name
        return unless profile.type == 'Coverage'
        must_supports[:elements].delete_if { |element| element[:path] == 'class:group.name' }
      end

      # US Core v6.1.0 Patch FHIR-50288, Remove these MustSupport elements from US Core Condition Encounter Diagnosis:
      # - Condition.extension:assertedDate
      # - Condition.onsetDateTime
      # - clinical status
      # - verification status
      def remove_must_supports_from_encounter_diagnosis
        return unless profile.id == 'us-core-condition-encounter-diagnosis'
        must_supports[:extensions].delete_if { |extension| extension[:id] == 'Condition.extension:assertedDate' }
        must_supports[:elements].delete_if { |element| ['onsetDateTime', 'clinicalStatus', 'verificationStatus'].include?(element[:path]) }
        must_supports[:choices].delete_if { |choice| choice[:paths].include?('onsetDateTime') }
      end
    end
  end
end