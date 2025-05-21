require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV610
    class PractitionerReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Practitioner resource from Practitioner read interaction'
      description 'A server SHALL support the Practitioner read interaction.'

      id :us_core_v610_practitioner_read_test

      def resource_type
        'Practitioner'
      end

      def scratch_resources
        scratch[:practitioner_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'Practitioner'), delayed_reference: true)
      end
    end
  end
end
