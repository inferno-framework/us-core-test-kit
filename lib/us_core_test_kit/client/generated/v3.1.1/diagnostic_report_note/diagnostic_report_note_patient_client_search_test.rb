# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class DiagnosticReportNotePatientClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v311_diagnostic_report_note_patient_client_search_test
        title 'SHOULD support patient search of DiagnosticReportNote'
        description %(
          The client demonstrates SHOULD support for searching patient on DiagnosticReportNote.
        )
        optional true

        input :diagnostic_report_support,
              optional: true

        def required_params
          ["patient"]
        end

        def parent_optional?
          Inferno::Repositories::Tests.new.find(id)&.parent&.optional?
        end

        def skip_message
          "Inferno did not receive any requests for the `DiagnosticReport` resource type, so support for US Core DiagnosticReport Profile for Report and Note exchange is not expected."
        end

        def failure_message
          "No searches made for the `DiagnosticReport` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          if parent_optional?
            omit_if diagnostic_report_support.blank?, skip_message
          else
            skip_if diagnostic_report_support.blank?, skip_message
          end
          
          requests = load_tagged_requests(SEARCH_DIAGNOSTIC_REPORT_TAG)
          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
