require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class EncounterPatientTypeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Encounter search by patient + type'
    description %(
A server SHOULD support searching by
patient + type on the Encounter resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :us_core_311_encounter_patient_type_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def self.properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Encounter',
        search_param_names: ['patient', 'type'],
        possible_status_search: true,
        token_search_params: ['type']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:encounter_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
