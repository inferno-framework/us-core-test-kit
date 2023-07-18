require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV610
    class BodyTemperatureReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Observation resource from Observation read interaction'
      description 'A server SHALL support the Observation read interaction.'

      id :us_core_v610_body_temperature_read_test

      def resource_type
        'Observation'
      end

      def scratch_resources
        scratch[:body_temperature_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
