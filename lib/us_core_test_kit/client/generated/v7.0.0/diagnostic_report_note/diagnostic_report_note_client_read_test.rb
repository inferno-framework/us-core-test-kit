# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class DiagnosticReportNoteClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_diagnostic_report_note_client_read_test
        title 'SHALL support read of DiagnosticReportNote'
        description %(
          The client demonstrates SHALL support for reading DiagnosticReportNote.
        )

        input :diagnostic_report_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `DiagnosticReport` resource type, so support for US Core DiagnosticReport Profile for Report and Note Exchange is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core DiagnosticReport Profile for Report and Note Exchange: `DiagnosticReport/us-core-client-tests-diagnostic-report-note`."
        end

        run do
          if parent_optional?
            omit_if diagnostic_report_support.blank?, skip_message
          else
            skip_if diagnostic_report_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_DIAGNOSTIC_REPORT_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-diagnostic-report-note')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
