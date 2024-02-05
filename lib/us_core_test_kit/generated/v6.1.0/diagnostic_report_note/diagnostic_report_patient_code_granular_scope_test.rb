require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'
require_relative '../../../granular_scope_checker'

module USCoreTestKit
  module USCoreV610
    class DiagnosticReportPatientCodeGranularScopeTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeChecker

      title 'Server filters results for DiagnosticReport search by patient + code based on granular scopes'
      description %(
This test repeats all DiagnosticReport searches by
patient + code and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v610_DiagnosticReport_patient_code_granular_scope_test

      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'DiagnosticReport',
        search_param_names: ['patient', 'code']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:diagnostic_report_note_resources] ||= {}
      end

      run do
        run_scope_check_test
      end
    end
  end
end
