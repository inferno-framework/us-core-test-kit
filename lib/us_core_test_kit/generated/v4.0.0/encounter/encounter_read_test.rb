require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV400
    class EncounterReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Encounter resource from Encounter read interaction'
      description 'A server SHALL support the Encounter read interaction.'

      id :us_core_v400_encounter_read_test

      def resource_type
        'Encounter'
      end

      def scratch_resources
        scratch[:encounter_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'Encounter'))
      end
    end
  end
end
