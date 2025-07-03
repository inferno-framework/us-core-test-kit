require_relative '../../../../search_test'
require_relative '../../../../generator/group_metadata'
require_relative '../../../../granular_scope_search_test'

module USCoreTestKit
  module USCoreV800
    class ConditionPatientGranularScopeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeSearchTest

      title 'Server filters results for Condition search by patient based on granular scopes'
      description %(
This test repeats all Condition searches by
patient and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v800_Condition_patient_granular_scope_search_test
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Condition',
        search_param_names: ['patient']
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
