require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV800
    class OrganizationReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Organization resource from Organization read interaction'
      description 'A server SHALL support the Organization read interaction.'

      id :us_core_v800_organization_read_test

      def resource_type
        'Organization'
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'Organization'), delayed_reference: true)
      end
    end
  end
end
