require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV400
    class EncounterMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Encounter resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Encounter resources
        found previously for the following must support elements:

        * Encounter.class
      * Encounter.hospitalization
      * Encounter.hospitalization.dischargeDisposition
      * Encounter.identifier
      * Encounter.identifier.system
      * Encounter.identifier.value
      * Encounter.location
      * Encounter.location.location
      * Encounter.participant
      * Encounter.participant.individual
      * Encounter.participant.period
      * Encounter.participant.type
      * Encounter.period
      * Encounter.reasonCode
      * Encounter.reasonReference
      * Encounter.serviceProvider
      * Encounter.status
      * Encounter.subject
      * Encounter.type
      )

      id :us_core_v400_encounter_must_support_test

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
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
