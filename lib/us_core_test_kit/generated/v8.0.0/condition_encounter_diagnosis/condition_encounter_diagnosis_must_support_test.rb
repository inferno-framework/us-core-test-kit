require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV800
    class ConditionEncounterDiagnosisMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Condition resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Condition resources
        found previously for the following must support elements:

        * Condition.category
        * Condition.category:us-core
        * Condition.code
        * Condition.encounter
        * Condition.onsetDateTime or Condition.extension:assertedDate
        * Condition.recordedDate
        * Condition.subject

        For ONC USCDI requirements, each Condition must support the following additional elements:

        * Condition.recorder
      )
      verifies_requirements 'hl7.fhir.us.core_8.0.0@1',
                            'hl7.fhir.us.core_8.0.0@13',
                            'hl7.fhir.us.core_8.0.0@75',
                            'hl7.fhir.us.core_8.0.0@87',
                            'hl7.fhir.us.core_8.0.0@90',
                            'hl7.fhir.us.core_8.0.0@91',
                            'hl7.fhir.us.core_8.0.0@93',
                            'hl7.fhir.us.core_8.0.0@94',
                            'hl7.fhir.us.core_8.0.0@97',
                            'hl7.fhir.us.core_8.0.0@99',
                            'hl7.fhir.us.core_8.0.0@111',
                            'hl7.fhir.us.core_8.0.0@115',
                            'hl7.fhir.us.core_8.0.0@801',
                            'hl7.fhir.us.core_8.0.0@802',
                            'hl7.fhir.us.core_8.0.0@803',
                            'hl7.fhir.us.core_8.0.0@804',
                            'hl7.fhir.us.core_8.0.0@805',
                            'hl7.fhir.us.core_8.0.0@812',
                            'hl7.fhir.us.core_8.0.0@814',
                            'hl7.fhir.us.core_8.0.0@872'

      id :us_core_v800_condition_encounter_diagnosis_must_support_test

      def resource_type
        'Condition'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:condition_encounter_diagnosis_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
