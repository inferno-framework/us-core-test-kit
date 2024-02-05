require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'
require_relative '../../../granular_scope_checker'

module USCoreTestKit
  module USCoreV610
    class ObservationPatientCategoryDateGranularScopeTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeChecker

      title 'Server filters results for Observation search by patient + category + date based on granular scopes'
      description %(
This test repeats all Observation searches by
patient + category + date and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v610_Observation_patient_category_date_granular_scope_test

      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Observation',
        search_param_names: ['patient', 'category', 'date']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:observation_lab_resources] ||= {}
      end

      run do
        run_scope_check_test
      end
    end
  end
end
