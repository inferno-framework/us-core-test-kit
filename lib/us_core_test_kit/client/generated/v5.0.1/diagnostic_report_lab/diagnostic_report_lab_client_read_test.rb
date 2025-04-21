# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class DiagnosticReportLabClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v501_diagnostic_report_lab_client_read_test

        title 'SHALL support read of DiagnosticReportLab'

        description %(
          The client demonstrates SHALL support for reading DiagnosticReportLab.
        )

        def failure_message
          "Did not receive a request for `DiagnosticReport` with id: `us-core-client-tests-diagnostic-report-lab`."
        end

        run do
          requests = load_tagged_requests(READ_DIAGNOSTIC_REPORT_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'DiagnosticReport')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-diagnostic-report-lab')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
