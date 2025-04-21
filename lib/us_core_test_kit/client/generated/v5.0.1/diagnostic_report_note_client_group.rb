# frozen_string_literal: true

require_relative 'diagnostic_report_note/diagnostic_report_note_client_read_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_patient_category_client_search_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_patient_client_search_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_patient_category_date_client_search_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_patient_code_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV501
      class DiagnosticReportNoteClientGroup < Inferno::TestGroup
        id :us_core_client_v501_diagnostic_report_note

        title 'DiagnosticReport for Report and Note Exchange'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required DiagnosticReport queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-diagnostic-report-note`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + category
* patient
* patient + category + date
* patient + code

        )

        run_as_group

        test from: :us_core_v501_diagnostic_report_note_client_read_test
        test from: :us_core_v501_diagnostic_report_note_patient_category_client_search_test
        test from: :us_core_v501_diagnostic_report_note_patient_client_search_test
        test from: :us_core_v501_diagnostic_report_note_patient_category_date_client_search_test
        test from: :us_core_v501_diagnostic_report_note_patient_code_client_search_test
      end
    end
  end
end
