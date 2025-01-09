require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV800
    class LocationAddressSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Location search by address'
      description %(
A server SHALL support searching by
address on the Location resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

Additionally, this test will check that GET and POST search methods
return the same number of results. Search by POST is required by the
FHIR R4 specification, and these tests interpret search by GET as a
requirement of US Core v8.0.0.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/2025Jan/CapabilityStatement-us-core-server.html)

      )

      id :us_core_v800_location_address_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          first_search: true,
        resource_type: 'Location',
        search_param_names: ['address'],
        saves_delayed_references: true,
        test_post_search: true
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
