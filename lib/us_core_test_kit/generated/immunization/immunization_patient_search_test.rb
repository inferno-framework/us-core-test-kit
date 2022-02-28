require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ImmunizationPatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Immunization search by patient'
    description %(
A server SHALL support searching by
patient on the Immunization resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

This test verifies that the server supports searching by reference using
the form `patient=[id]` as well as `patient=Patient/[id]`. The two
different forms are expected to return the same number of results. US
Core requires that both forms are supported by US Core responders.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

Additionally, this test will check that GET and POST search methods
return the same number of results. Search by POST is required by the
FHIR R4 specification, and these tests interpret search by GET as a
requirement of US Core v3.1.1.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :us_core_311_immunization_patient_search_test
    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'

    def self.properties
      @properties ||= SearchTestProperties.new(
        first_search: true,
        resource_type: 'Immunization',
        search_param_names: ['patient'],
        possible_status_search: true,
        test_reference_variants: true,
        test_post_search: true
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:immunization_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
