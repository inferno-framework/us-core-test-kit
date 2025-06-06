# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class DiagnosticReportNoteClientSupportTest < Inferno::Test
        include TestHelper

        id :us_core_v400_diagnostic_report_note_client_support_test
        title 'Support DiagnosticReport Resource Access'
        description %(
          
            This test checks whether the client made requests for the DiagnosticReport FHIR resource type.
            If so, it will be expected to demonstrate all required searches and retrieve target
            instance `us-core-client-tests-diagnostic-report-note` for the US Core DiagnosticReport Profile for Report and Note exchange.
          
        )

        output :diagnostic_report_support

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "No requests made for `DiagnosticReport`."
        end

        run do
          diagnostic_report_read_requests = load_tagged_requests(READ_DIAGNOSTIC_REPORT_TAG)
          diagnostic_report_search_requests = load_tagged_requests(SEARCH_DIAGNOSTIC_REPORT_TAG)
          diagnostic_report_support = 
            diagnostic_report_read_requests.length > 0 ||
            diagnostic_report_search_requests.length > 0
          if parent_optional?
            omit_if !diagnostic_report_support, skip_message
          else
            skip_if !diagnostic_report_support, skip_message
          end

          (output diagnostic_report_support:)
        end
      end
    end
  end
end
