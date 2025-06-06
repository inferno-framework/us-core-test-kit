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

        input :diagnostic_report_support,
              optional: true

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `DiagnosticReport` resource type, so support for US Core DiagnosticReport Profile for Laboratory Results Reporting is not expected."
        end

        def failure_message
          "Inferno did not receive the expected read request for the target instance of the US Core DiagnosticReport Profile for Laboratory Results Reporting: `DiagnosticReport/us-core-client-tests-diagnostic-report-lab`."
        end

        run do
          if parent_optional?
            omit_if diagnostic_report_support.blank?, skip_message
          else
            skip_if diagnostic_report_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(READ_DIAGNOSTIC_REPORT_TAG)
          requests_for_id = filter_requests_by_resource_id(requests, 'us-core-client-tests-diagnostic-report-lab')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
