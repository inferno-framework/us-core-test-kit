require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV800
    class EncounterClassPatientSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Encounter search by class + patient'
      description %(
A server SHOULD support searching by
class + patient on the Encounter resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU8/CapabilityStatement-us-core-server.html)

      )

      id :us_core_v800_encounter_class_patient_search_test
      optional
  
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Encounter',
        search_param_names: ['class', 'patient'],
        possible_status_search: true,
        token_search_params: ['class']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:encounter_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
