require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV610
    class SpecimenIdSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Specimen search by _id'
      description %(
A server SHALL support searching by
_id on the Specimen resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :us_core_v610_specimen__id_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Specimen',
        search_param_names: ['_id']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:specimen_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
