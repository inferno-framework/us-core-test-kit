require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module USCoreTestKit
  module USCoreV311
    class PediatricBmiForAgeReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      include ResourceList

      title 'MustSupport reference within Observation resources can be read'
      description %(
        This test will attempt to read MustSupport references found in the
        resources from the first search. This test will look through the Observation resources
        found previously for the following must support elements:

        * Observation.subject
      )

      id :us_core_v311_pediatric_bmi_for_age_reference_resolution_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:pediatric_bmi_for_age_resources] ||= {}
      end

      run do
        perform_reference_resolution_test
      end
    end
  end
end
