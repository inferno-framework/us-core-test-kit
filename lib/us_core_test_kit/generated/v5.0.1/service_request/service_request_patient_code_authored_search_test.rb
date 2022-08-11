require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV501
    class ServiceRequestPatientCodeAuthoredSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for ServiceRequest search by patient + code + authored'
      description %(
A server SHOULD support searching by
patient + code + authored on the ServiceRequest resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :us_core_v501_service_request_patient_code_authored_search_test
      optional
  
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'ServiceRequest',
        search_param_names: ['patient', 'code', 'authored'],
        possible_status_search: true,
        token_search_params: ['code'],
        params_with_comparators: ['authored']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:service_request_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
