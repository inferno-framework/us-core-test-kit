require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV501
    class ConditionProblemsHealthConcernsMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Condition resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Condition resources
        found previously for the following must support elements:

        * Condition.abatementDateTime
        * Condition.category
        * Condition.category:sdoh
        * Condition.category:us-core
        * Condition.clinicalStatus
        * Condition.code
        * Condition.extension:assertedDate
        * Condition.onsetDateTime
        * Condition.recordedDate
        * Condition.subject
        * Condition.verificationStatus
      )

      id :us_core_v501_condition_problems_health_concerns_must_support_test

      def resource_type
        'Condition'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:condition_problems_health_concerns_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
