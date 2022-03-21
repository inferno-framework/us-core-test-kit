require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module USCoreTestKit
  module USCoreV400
    class AllergyIntoleranceReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      include ResourceList

      title 'MustSupport reference within AllergyIntolerance resources can be read'
      description %(
        This test will attempt to read MustSupport references found in the
        resources from the first search. This test will look through the AllergyIntolerance resources
        found previously for the following must support elements:

        * AllergyIntolerance.patient
      )

      id :us_core_v400_allergy_intolerance_reference_resolution_test

      def resource_type
        'AllergyIntolerance'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:allergy_intolerance_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
