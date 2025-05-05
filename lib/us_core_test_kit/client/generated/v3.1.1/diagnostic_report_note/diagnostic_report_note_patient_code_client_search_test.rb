# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV311
      class DiagnosticReportNotePatientCodeClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v311_diagnostic_report_note_patient_code_client_search_test

        title 'SHALL support patient + code search of DiagnosticReportNote'

        description %(
          The client demonstrates SHALL support for searching patient + code on DiagnosticReportNote.
        )

        def required_params
          ["patient", "code"]
        end

        def failure_message
          "Did not receive a request for `DiagnosticReport` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_DIAGNOSTIC_REPORT_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'DiagnosticReport')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
