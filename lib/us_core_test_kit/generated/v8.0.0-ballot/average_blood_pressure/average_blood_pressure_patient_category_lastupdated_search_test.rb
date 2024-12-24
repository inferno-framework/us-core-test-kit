require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV800_BALLOT
    class AverageBloodPressurePatientCategoryLastupdatedSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Observation search by patient + category + _lastUpdated'
      description %(
A server SHOULD support searching by
patient + category + _lastUpdated on the Observation resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](/CapabilityStatement-us-core-server.html)

      )

      id :us_core_v800_ballot_average_blood_pressure_patient_category__lastUpdated_search_test
      optional
  
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Observation',
        search_param_names: ['patient', 'category', '_lastUpdated'],
        possible_status_search: true,
        token_search_params: ['category']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:average_blood_pressure_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
