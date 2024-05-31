require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV700
    class ConditionProblemsHealthConcernsReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Condition resource from Condition read interaction'
      description 'A server SHALL support the Condition read interaction.'

      id :us_core_v700_condition_problems_health_concerns_read_test

      def resource_type
        'Condition'
      end

      def scratch_resources
        scratch[:condition_problems_health_concerns_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
