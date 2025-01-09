require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV800
    class LocationAddressCitySearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Location search by address-city'
      description %(
A server SHOULD support searching by
address-city on the Location resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/2025Jan/CapabilityStatement-us-core-server.html)

      )

      id :us_core_v800_location_address_city_search_test
      optional
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Location',
        search_param_names: ['address-city']
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
