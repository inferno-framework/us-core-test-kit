require_relative '../../../../search_test'
require_relative '../../../../generator/group_metadata'
require_relative '../../../../granular_scope_checker'

module USCoreTestKit
  module USCoreV700_BALLOT
    class ServiceRequestPatientCodeAuthoredGranularScopeTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeChecker

      title 'Server filters results for ServiceRequest search by patient + code + authored based on granular scopes'
      description %(
This test repeats all ServiceRequest searches by
patient + code + authored and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v700_ballot_ServiceRequest_patient_code_authored_granular_scope_test

      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'ServiceRequest',
        search_param_names: ['patient', 'code', 'authored']
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
