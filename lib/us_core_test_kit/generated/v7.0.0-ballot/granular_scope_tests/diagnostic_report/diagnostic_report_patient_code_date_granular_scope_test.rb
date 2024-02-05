require_relative '../../../../search_test'
require_relative '../../../../generator/group_metadata'
require_relative '../../../../granular_scope_checker'

module USCoreTestKit
  module USCoreV700_BALLOT
    class DiagnosticReportPatientCodeDateGranularScopeTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeChecker

      title 'Server filters results for DiagnosticReport search by patient + code + date based on granular scopes'
      description %(
This test repeats all DiagnosticReport searches by
patient + code + date and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v700_ballot_DiagnosticReport_patient_code_date_granular_scope_test

      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'DiagnosticReport',
        search_param_names: ['patient', 'code', 'date']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      run do
        run_scope_check_test
      end
    end
  end
end
