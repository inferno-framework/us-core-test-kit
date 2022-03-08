require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV311
    class ProcedureReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Procedure resource from Procedure read interaction'
      description 'A server SHALL support the Procedure read interaction.'

      id :us_core_v311_procedure_read_test

      def resource_type
        'Procedure'
      end

      def scratch_resources
        scratch[:procedure_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
