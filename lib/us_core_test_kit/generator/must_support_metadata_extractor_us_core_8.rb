require_relative 'must_support_metadata_extractor_us_core_6'

module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore8
      attr_accessor :profile, :must_supports

      def initialize(profile, must_supports)
        self.profile = profile
        self.must_supports = must_supports
      end

      def us_core_6_extractor
        @us_core_6_extractor ||= MustSupportMetadataExtractorUsCore6.new(profile, must_supports)
      end

      def us_core_7_extractor
        @us_core_7_extractor ||= MustSupportMetadataExtractorUsCore7.new(profile, must_supports)
      end

      def remove_patient_and_encounter_interpreter_extension
        return unless profile.type == 'Patient' || profile.type == 'Encounter'

        must_supports[:extensions].delete_if { |extension| extension[:url].end_with?('us-core-interpreter-needed') }
      end

      def handle_special_cases
        us_core_6_extractor.add_patient_uscdi_elements
        add_must_support_choices
        us_core_6_extractor.remove_practitioner_address
        remove_patient_and_encounter_interpreter_extension
      end

      def add_must_support_choices
        us_core_7_extractor.add_must_support_choices
      end
    end
  end
end
