require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV311
    class DiagnosticReportLabReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct DiagnosticReport resource from DiagnosticReport read interaction'
      description 'A server SHALL support the DiagnosticReport read interaction.'

      id :us_core_v311_diagnostic_report_lab_read_test

      def resource_type
        'DiagnosticReport'
      end

      def scratch_resources
        scratch[:diagnostic_report_lab_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
