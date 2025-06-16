require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV700
    class ObservationLabMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Observation resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Observation resources
        found previously for the following must support elements:

        * Observation.category
        * Observation.category:us-core
        * Observation.code
        * Observation.effectiveDateTime
        * Observation.encounter
        * Observation.interpretation
        * Observation.meta
        * Observation.meta.lastUpdated
        * Observation.referenceRange
        * Observation.specimen
        * Observation.status
        * Observation.subject
        * Observation.valueCodeableConcept
        * Observation.valueQuantity
        * Observation.valueString
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@1', 'hl7.fhir.us.core_7.0.0@13',
                            'hl7.fhir.us.core_7.0.0@75', 'hl7.fhir.us.core_7.0.0@87',
                            'hl7.fhir.us.core_7.0.0@88', 'hl7.fhir.us.core_7.0.0@90',
                            'hl7.fhir.us.core_7.0.0@91', 'hl7.fhir.us.core_7.0.0@111',
                            'hl7.fhir.us.core_7.0.0@115'

      id :us_core_v700_observation_lab_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:observation_lab_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
