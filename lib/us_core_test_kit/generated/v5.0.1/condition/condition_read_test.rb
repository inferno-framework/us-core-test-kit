require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV501
    class ConditionReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Condition resource from Condition read interaction'
      description 'A server SHALL support the Condition read interaction.'

      id :us_core_v501_condition_read_test

      def resource_type
        'Condition'
      end

      def scratch_resources
        scratch[:condition_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
