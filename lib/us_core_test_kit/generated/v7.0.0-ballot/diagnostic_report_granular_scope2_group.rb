require_relative 'diagnostic_report_note/diagnostic_report_patient_category_granular_scope_test'
require_relative 'diagnostic_report_note/diagnostic_report_patient_granular_scope_test'
require_relative 'diagnostic_report_note/diagnostic_report_patient_category_date_granular_scope_test'
require_relative 'diagnostic_report_note/diagnostic_report_patient_code_granular_scope_test'
require_relative 'diagnostic_report_note/diagnostic_report_patient_status_granular_scope_test'
require_relative 'diagnostic_report_note/diagnostic_report_patient_code_date_granular_scope_test'

module USCoreTestKit
  module USCoreV700_BALLOT
    class DiagnosticReportGranularScope2Group < Inferno::TestGroup
      title 'DiagnosticReport Granular Scope Tests Tests'
      short_description 'Verify support for the server capabilities required by the US Core DiagnosticReport Profile for Report and Note Exchange.'
      description %(
  The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `DiagnosticReport.rs?category=http://loinc.org|LP7839-6`
* `DiagnosticReport.rs?category=http://terminology.hl7.org/CodeSystem/v2-0074|LAB`

      )

      id :us_core_v700_ballot_diagnostic_report_granular_scope_2_group
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'diagnostic_report_note', 'metadata.yml'), aliases: true))
      end
    
      test from: :us_core_v700_ballot_DiagnosticReport_patient_category_granular_scope_test
      test from: :us_core_v700_ballot_DiagnosticReport_patient_granular_scope_test
      test from: :us_core_v700_ballot_DiagnosticReport_patient_category_date_granular_scope_test
      test from: :us_core_v700_ballot_DiagnosticReport_patient_code_granular_scope_test
      test from: :us_core_v700_ballot_DiagnosticReport_patient_status_granular_scope_test
      test from: :us_core_v700_ballot_DiagnosticReport_patient_code_date_granular_scope_test
    end
  end
end
