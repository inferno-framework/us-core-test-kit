require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCoreTestKit
  class EncounterIdSearchTest < Inferno::Test
    include USCoreTestKit::SearchTest

    title 'Server returns valid results for Encounter search by _id'
    description %(
A server SHALL support searching by
_id on the Encounter resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :us_core_311_encounter__id_search_test
    def self.properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Encounter',
        search_param_names: ['_id'],
        possible_status_search: true
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
