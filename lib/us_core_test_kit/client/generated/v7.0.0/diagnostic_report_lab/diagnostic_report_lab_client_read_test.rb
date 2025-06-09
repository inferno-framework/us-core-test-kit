# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class DiagnosticReportLabClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_diagnostic_report_lab_client_read_test
        title 'SHALL support read of DiagnosticReportLab'
        description %(
          The client demonstrates SHALL support for reading DiagnosticReportLab.
        )

        def skip_message
          "Inferno did not receive any read requests for the `DiagnosticReport` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core DiagnosticReport Profile for Laboratory Results Reporting: `DiagnosticReport/us-core-client-tests-diagnostic-report-lab`."
        end

        run do
          requests = load_tagged_requests(READ_DIAGNOSTIC_REPORT_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-diagnostic-report-lab')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
