module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore7
      attr_accessor :profile, :must_supports

      def initialize(profile, must_supports)
        self.profile = profile
        self.must_supports = must_supports
      end

      def us_core_6_extractor
        @us_core_6_extractor ||= MustSupportMetadataExtractorUsCore6.new(profile, must_supports)
      end

      def handle_special_cases
        us_core_6_extractor.add_patient_uscdi_elements
        add_must_support_choices
        us_core_6_extractor.remove_practitioner_address
        us_core_6_extractor.remove_patient_gender_identity
        us_core_6_extractor.remove_coverage_group_name
        us_core_6_extractor.remove_medicationdispense_practitioner
        us_core_6_extractor.remove_must_supports_from_encounter_diagnosis
      end

      def add_must_support_choices
        us_core_6_extractor.add_must_support_choices

        more_choices = []

        case profile.type
        when 'Procedure'
          more_choices << {
            paths: ['reasonCode', 'reasonReference'],
            uscdi_only: true
          }
        end

        return if more_choices.empty?

        must_supports[:choices] ||= []
        must_supports[:choices].concat(more_choices)
      end
    end
  end
end
