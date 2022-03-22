require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module USCoreTestKit
  module USCoreV311
    class EncounterReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      include ResourceList

      title 'MustSupport reference within Encounter resources can be read'
      description %(
        This test will attempt to read MustSupport references found in the
        resources from the first search. This test will look through the Encounter resources
        found previously for the following must support elements:

        * Encounter.location.location
      * Encounter.participant.individual
      * Encounter.subject
      )

      id :us_core_v311_encounter_reference_resolution_test

      def resource_type
        'Encounter'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:encounter_resources] ||= {}
      end

      run do
        perform_reference_resolution_test
      end
    end
  end
end
