require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV400
    class GoalMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Goal resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Goal resources
        found previously for the following must support elements:

        * Goal.description
      * Goal.lifecycleStatus
      * Goal.subject
      * Goal.target
      * Goal.target.dueDate
      )

      id :us_core_v400_goal_must_support_test

      def resource_type
        'Goal'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:goal_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
