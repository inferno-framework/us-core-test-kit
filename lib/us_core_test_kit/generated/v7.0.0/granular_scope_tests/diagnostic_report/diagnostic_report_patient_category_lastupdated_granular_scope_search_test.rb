require_relative '../../../../search_test'
require_relative '../../../../generator/group_metadata'
require_relative '../../../../granular_scope_search_test'

module USCoreTestKit
  module USCoreV700
    class DiagnosticReportPatientCategoryLastupdatedGranularScopeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeSearchTest

      title 'Server filters results for DiagnosticReport search by patient + category + _lastUpdated based on granular scopes'
      description %(
This test repeats all DiagnosticReport searches by
patient + category + _lastUpdated and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v700_DiagnosticReport_patient_category__lastUpdated_granular_scope_search_test

      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'DiagnosticReport',
        search_param_names: ['patient', 'category', '_lastUpdated']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      run do
        run_scope_search_test
      end
    end
  end
end
