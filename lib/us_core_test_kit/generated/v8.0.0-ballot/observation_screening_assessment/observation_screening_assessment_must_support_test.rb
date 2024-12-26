require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV800_BALLOT
    class ObservationScreeningAssessmentMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Observation resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Observation resources
        found previously for the following must support elements:

        * Observation.category
        * Observation.category:screening-assessment
        * Observation.category:survey
        * Observation.code
        * Observation.derivedFrom
        * Observation.effectiveDateTime
        * Observation.hasMember
        * Observation.performer
        * Observation.status
        * Observation.subject
        * Observation.valueCodeableConcept
        * Observation.valueQuantity
        * Observation.valueString
      )

      id :us_core_v800_ballot_observation_screening_assessment_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:observation_screening_assessment_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
