require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV600_BALLOT
    class PediatricBmiForAgePatientCategoryStatusSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Observation search by patient + category + status'
      description %(
A server SHOULD support searching by
patient + category + status on the Observation resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :us_core_v600_ballot_pediatric_bmi_for_age_patient_category_status_search_test
      optional
  
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Observation',
        search_param_names: ['patient', 'category', 'status'],
        token_search_params: ['category'],
        multiple_or_search_params: ['status']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:pediatric_bmi_for_age_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
