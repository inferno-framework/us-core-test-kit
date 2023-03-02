require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV600_BALLOT
    class SpecimenReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Specimen resource from Specimen read interaction'
      description 'A server SHALL support the Specimen read interaction.'

      id :us_core_v600_ballot_specimen_read_test

      def resource_type
        'Specimen'
      end

      def scratch_resources
        scratch[:specimen_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'Specimen'))
      end
    end
  end
end
