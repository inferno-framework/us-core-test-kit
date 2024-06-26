require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV700
    class GoalReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Goal resource from Goal read interaction'
      description 'A server SHALL support the Goal read interaction.'

      id :us_core_v700_goal_read_test

      def resource_type
        'Goal'
      end

      def scratch_resources
        scratch[:goal_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
