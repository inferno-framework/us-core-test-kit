require_relative '../../../../search_test'
require_relative '../../../../generator/group_metadata'
require_relative '../../../../granular_scope_search_test'

module USCoreTestKit
  module USCoreV700
    class ServiceRequestPatientCategoryGranularScopeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeSearchTest

      title 'Server filters results for ServiceRequest search by patient + category based on granular scopes'
      description %(
This test repeats all ServiceRequest searches by
patient + category and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v700_ServiceRequest_patient_category_granular_scope_search_test

      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'ServiceRequest',
        search_param_names: ['patient', 'category']
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
