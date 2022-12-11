require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV600_BALLOT
    class CoverageReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Coverage resource from Coverage read interaction'
      description 'A server SHALL support the Coverage read interaction.'

      id :us_core_v600_ballot_coverage_read_test

      def resource_type
        'Coverage'
      end

      def scratch_resources
        scratch[:coverage_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
