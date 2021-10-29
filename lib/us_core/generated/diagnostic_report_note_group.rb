require_relative 'diagnostic_report_note_read_test'

module USCore
  class DiagnosticReportNoteGroup < Inferno::TestGroup
    title 'DiagnosticReportNote Tests'
    # description ''

    id :diagnostic_report_note

    test from: :diagnostic_report_note_read_test
  end
end
