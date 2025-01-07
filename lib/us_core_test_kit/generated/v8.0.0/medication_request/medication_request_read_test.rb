require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV800
    class MedicationRequestReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct MedicationRequest resource from MedicationRequest read interaction'
      description 'A server SHALL support the MedicationRequest read interaction.'

      id :us_core_v800_medication_request_read_test

      def resource_type
        'MedicationRequest'
      end

      def scratch_resources
        scratch[:medication_request_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
