require_relative '../../../../search_test'
require_relative '../../../../generator/group_metadata'
require_relative '../../../../granular_scope_checker'

module USCoreTestKit
  module USCoreV700_BALLOT
    class DocumentReferencePatientTypePeriodGranularScopeTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeChecker

      title 'Server filters results for DocumentReference search by patient + type + period based on granular scopes'
      description %(
This test repeats all DocumentReference searches by
patient + type + period and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v700_ballot_DocumentReference_patient_type_period_granular_scope_test

      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'DocumentReference',
        search_param_names: ['patient', 'type', 'period']
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
