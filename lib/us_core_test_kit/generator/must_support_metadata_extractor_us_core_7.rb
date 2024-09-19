require_relative 'must_support_metadata_extractor_us_core_6'

module USCoreTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore7
      attr_accessor :profile, :must_supports

      US_CORE_CATEGORY = ['sdoh', 'functional-status', 'disability-status', 'cognitive-status'].freeze

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
