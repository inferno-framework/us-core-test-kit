require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV700_BALLOT
    class MedicationDispenseReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct MedicationDispense resource from MedicationDispense read interaction'
      description 'A server SHALL support the MedicationDispense read interaction.'

      id :us_core_v700_ballot_medication_dispense_read_test

      def resource_type
        'MedicationDispense'
      end

      def scratch_resources
        scratch[:medication_dispense_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
