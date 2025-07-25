# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV400
      class DiagnosticReportNotePatientCodeClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v400_diagnostic_report_note_patient_code_client_search_test
        title 'SHOULD support patient + code search of DiagnosticReportNote'
        description %(
          The client demonstrates SHOULD support for searching patient + code on DiagnosticReportNote.
        )
        optional true

        def required_params
          ["patient", "code"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `DiagnosticReport` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `DiagnosticReport` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_DIAGNOSTIC_REPORT_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
