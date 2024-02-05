require_relative './granular_scope_tests/diagnostic_report/diagnostic_report_patient_category_granular_scope_test'
require_relative './granular_scope_tests/diagnostic_report/diagnostic_report_patient_granular_scope_test'
require_relative './granular_scope_tests/diagnostic_report/diagnostic_report_patient_category_date_granular_scope_test'
require_relative './granular_scope_tests/diagnostic_report/diagnostic_report_patient_code_granular_scope_test'
require_relative './granular_scope_tests/diagnostic_report/diagnostic_report_patient_status_granular_scope_test'
require_relative './granular_scope_tests/diagnostic_report/diagnostic_report_patient_code_date_granular_scope_test'

module USCoreTestKit
  module USCoreV700_BALLOT
    class DiagnosticReportGranularScope1Group < Inferno::TestGroup
      title 'DiagnosticReport Granular Scope Tests Tests'
      short_description 'Verify support for the server capabilities required by the US Core DiagnosticReport Profile for Report and Note Exchange.'
      description %(
  The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `DiagnosticReport.rs?category=http://loinc.org|LP29684-5`
* `DiagnosticReport.rs?category=http://loinc.org|LP29708-2`

      )

      id :us_core_v700_ballot_diagnostic_report_granular_scope_1_group
      run_as_group

    
      test from: :us_core_v700_ballot_DiagnosticReport_patient_category_granular_scope_test
      test from: :us_core_v700_ballot_DiagnosticReport_patient_granular_scope_test
      test from: :us_core_v700_ballot_DiagnosticReport_patient_category_date_granular_scope_test
      test from: :us_core_v700_ballot_DiagnosticReport_patient_code_granular_scope_test
      test from: :us_core_v700_ballot_DiagnosticReport_patient_status_granular_scope_test
      test from: :us_core_v700_ballot_DiagnosticReport_patient_code_date_granular_scope_test
    end
  end
end
