require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module USCoreTestKit
  module USCoreV400
    class PulseOximetryReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      include ResourceList

      title 'MustSupport references within Observation resources are valid'
      description %(
        This test will attempt to read external references provided within elements
        marked as 'MustSupport', if any are available.

        It verifies that at least one external reference for each MustSupport Reference element
        can be accessed by the test client, and conforms to corresponding US Core profile.

        Elements which may provide external references include:

        * Observation.subject
      )

      id :us_core_v400_pulse_oximetry_reference_resolution_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:pulse_oximetry_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
