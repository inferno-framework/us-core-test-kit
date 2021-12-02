require_relative 'diagnostic_report_note/diagnostic_report_note_patient_category_search_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_patient_search_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_patient_category_date_search_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_patient_status_search_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_patient_code_date_search_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_patient_code_search_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_read_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_provenance_revinclude_search_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_validation_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_must_support_test'
require_relative 'diagnostic_report_note/diagnostic_report_note_reference_resolution_test'

module USCore
  class DiagnosticReportNoteGroup < Inferno::TestGroup
    title 'DiagnosticReportNote Tests'
    # description ''

    id :diagnostic_report_note

    test from: :diagnostic_report_note_patient_category_search_test
    test from: :diagnostic_report_note_patient_search_test
    test from: :diagnostic_report_note_patient_category_date_search_test
    test from: :diagnostic_report_note_patient_status_search_test
    test from: :diagnostic_report_note_patient_code_date_search_test
    test from: :diagnostic_report_note_patient_code_search_test
    test from: :diagnostic_report_note_read_test
    test from: :diagnostic_report_note_provenance_revinclude_search_test
    test from: :diagnostic_report_note_validation_test
    test from: :diagnostic_report_note_must_support_test
    test from: :diagnostic_report_note_reference_resolution_test
  end
end
