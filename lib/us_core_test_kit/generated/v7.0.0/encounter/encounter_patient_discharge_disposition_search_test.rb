require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV700
    class EncounterPatientDischargeDispositionSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Encounter search by patient + discharge-disposition'
      description %(
A server SHOULD support searching by
patient + discharge-disposition on the Encounter resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :us_core_v700_encounter_patient_discharge_disposition_search_test
      optional
  
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Encounter',
        search_param_names: ['patient', 'discharge-disposition'],
        possible_status_search: true,
        token_search_params: ['discharge-disposition']
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
