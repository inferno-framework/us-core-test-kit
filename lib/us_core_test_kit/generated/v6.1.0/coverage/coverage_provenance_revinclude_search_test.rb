require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV610
    class CoverageProvenanceRevincludeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns Provenance resources from Coverage search by patient + revInclude:Provenance:target'
      description %(
        A server SHALL be capable of supporting _revIncludes:Provenance:target.

        This test will perform a search by patient + revInclude:Provenance:target and
        will pass if a Provenance resource is found in the response.
      %)

      id :us_core_v610_coverage_provenance_revinclude_search_test
  
      verifies_requirements 'hl7.fhir.us.core_6.1.0@493'

      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Coverage',
        search_param_names: ['patient']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.provenance_metadata
        @provenance_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'provenance', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:coverage_resources] ||= {}
      end

      def scratch_provenance_resources
        scratch[:provenance_resources] ||= {}
      end

      run do
        run_provenance_revinclude_search_test
      end
    end
  end
end
