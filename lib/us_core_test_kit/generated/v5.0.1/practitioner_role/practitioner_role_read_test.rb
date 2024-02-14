require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV501
    class PractitionerRoleReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct PractitionerRole resource from PractitionerRole read interaction'
      description 'A server SHALL support the PractitionerRole read interaction.'

      id :us_core_v501_practitioner_role_read_test

      def resource_type
        'PractitionerRole'
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'PractitionerRole'))
      end
    end
  end
end
