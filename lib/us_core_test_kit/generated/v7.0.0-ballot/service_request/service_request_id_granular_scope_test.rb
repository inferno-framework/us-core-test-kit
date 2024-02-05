require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'
require_relative '../../../granular_scope_checker'

module USCoreTestKit
  module USCoreV700_BALLOT
    class ServiceRequestIdGranularScopeTest < Inferno::Test
      include USCoreTestKit::SearchTest
      include USCoreTestKit::GranularScopeChecker

      title 'Server filters results for ServiceRequest search by _id based on granular scopes'
      description %(
This test repeats all ServiceRequest searches by
_id and verifies that the results have been
filtered based on the granted granular scopes.

      )

      id :us_core_v700_ballot_ServiceRequest__id_granular_scope_test

      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'ServiceRequest',
        search_param_names: ['_id']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:service_request_resources] ||= {}
      end

      run do
        run_scope_check_test
      end
    end
  end
end
