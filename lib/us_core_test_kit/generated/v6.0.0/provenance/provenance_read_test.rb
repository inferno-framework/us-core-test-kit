require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV600
    class ProvenanceReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Provenance resource from Provenance read interaction'
      description 'A server SHALL support the Provenance read interaction.'

      id :us_core_v600_provenance_read_test

      def resource_type
        'Provenance'
      end

      def scratch_resources
        scratch[:provenance_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
