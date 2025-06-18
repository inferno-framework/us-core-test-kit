# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV800
      class DiagnosticReportNoteClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v800_diagnostic_report_note_client_read_test
        title 'SHALL support read of DiagnosticReportNote'
        description %(
          The client demonstrates SHALL support for reading DiagnosticReportNote.
        )

        def skip_message
          "Inferno did not receive any read requests for the `DiagnosticReport` resource type."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core DiagnosticReport Profile for Report and Note Exchange: `DiagnosticReport/us-core-client-tests-diagnostic-report-note`."
        end

        run do
          requests = load_tagged_requests(READ_DIAGNOSTIC_REPORT_TAG)
          skip_if requests.blank?, skip_message

          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-diagnostic-report-note')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
