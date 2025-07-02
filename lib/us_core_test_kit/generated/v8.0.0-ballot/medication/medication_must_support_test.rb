require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV800_BALLOT
    class MedicationMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Medication resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Medication resources
        found previously for the following must support elements:

        * Medication.code
      )

      id :us_core_v800_ballot_medication_must_support_test

      def resource_type
        'Medication'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
