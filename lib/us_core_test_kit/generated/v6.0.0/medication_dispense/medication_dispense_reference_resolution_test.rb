require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module USCoreTestKit
  module USCoreV600
    class MedicationDispenseReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest
      include ResourceList

      title 'MustSupport references within MedicationDispense resources are valid'
      description %(
        This test will attempt to read external references provided within elements
        marked as 'MustSupport', if any are available.

        It verifies that at least one external reference for each MustSupport Reference element
        can be accessed by the test client, and conforms to corresponding US Core profile.

        Elements which may provide external references include:

        * MedicationDispense.authorizingPrescription
        * MedicationDispense.medication[x]
        * MedicationDispense.performer.actor
        * MedicationDispense.subject
      )

      id :us_core_v600_medication_dispense_reference_resolution_test

      def resource_type
        'MedicationDispense'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_dispense_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
