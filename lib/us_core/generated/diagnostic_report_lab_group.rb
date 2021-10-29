require_relative 'diagnostic_report_lab_read_test'

module USCore
  class DiagnosticReportLabGroup < Inferno::TestGroup
    title 'DiagnosticReportLab Tests'
    # description ''

    id :diagnostic_report_lab

    test from: :diagnostic_report_lab_read_test
  end
end
