require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'
require_relative '../../../granular_scope_checker'

module USCoreTestKit
  module USCoreV610
    class ConditionPatientOnsetDateGranularScopeTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeChecker

      title 'Server filters results for Condition search by patient + onset-date based on granular scopes'
      description %(
This test repeats all Condition searches by
patient + onset-date and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v610_Condition_patient_onset_date_granular_scope_test

      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Condition',
        search_param_names: ['patient', 'onset-date']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:condition_encounter_diagnosis_resources] ||= {}
      end

      run do
        run_scope_check_test
      end
    end
  end
end
