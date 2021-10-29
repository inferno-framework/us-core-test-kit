require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_category_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_status_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_category_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_code_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_date_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_category_date_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_status_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_code_date_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_patient_code_search_test'
require_relative 'diagnostic_report_lab/diagnostic_report_lab_read_test'

module USCore
  class DiagnosticReportLabGroup < Inferno::TestGroup
    title 'DiagnosticReportLab Tests'
    # description ''

    id :diagnostic_report_lab

    test from: :diagnostic_report_lab_patient_category_search_test
    test from: :diagnostic_report_lab_status_search_test
    test from: :diagnostic_report_lab_patient_search_test
    test from: :diagnostic_report_lab_category_search_test
    test from: :diagnostic_report_lab_code_search_test
    test from: :diagnostic_report_lab_date_search_test
    test from: :diagnostic_report_lab_patient_category_date_search_test
    test from: :diagnostic_report_lab_patient_status_search_test
    test from: :diagnostic_report_lab_patient_code_date_search_test
    test from: :diagnostic_report_lab_patient_code_search_test
    test from: :diagnostic_report_lab_read_test
  end
end
