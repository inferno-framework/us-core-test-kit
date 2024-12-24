require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV800_BALLOT
    class MedicationReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Medication resource from Medication read interaction'
      description 'A server SHALL support the Medication read interaction.'

      id :us_core_v800_ballot_medication_read_test

      def resource_type
        'Medication'
      end

      def scratch_resources
        scratch[:medication_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'Medication'))
      end
    end
  end
end
