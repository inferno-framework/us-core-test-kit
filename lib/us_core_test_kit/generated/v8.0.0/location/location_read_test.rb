require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV800
    class LocationReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Location resource from Location read interaction'
      description 'A server SHALL support the Location read interaction.'

      id :us_core_v800_location_read_test

      def resource_type
        'Location'
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'Location'), delayed_reference: true)
      end
    end
  end
end
