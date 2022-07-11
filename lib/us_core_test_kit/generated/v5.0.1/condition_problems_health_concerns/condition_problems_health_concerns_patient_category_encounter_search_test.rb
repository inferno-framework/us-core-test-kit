require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV501
    class ConditionProblemsHealthConcernsPatientCategoryEncounterSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Condition search by patient + category + encounter'
      description %(
A server SHOULD support searching by
patient + category + encounter on the Condition resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :us_core_v501_condition_problems_health_concerns_patient_category_encounter_search_test
      optional
  
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Condition',
        search_param_names: ['patient', 'category', 'encounter'],
        possible_status_search: true,
        token_search_params: ['category']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:condition_problems_health_concerns_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
