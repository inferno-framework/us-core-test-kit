require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV600_BALLOT
    class DocumentReferencePatientCategorySearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for DocumentReference search by patient + category'
      description %(
A server SHALL support searching by
patient + category on the DocumentReference resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :us_core_v600_ballot_document_reference_patient_category_search_test
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'DocumentReference',
        search_param_names: ['patient', 'category'],
        possible_status_search: true,
        token_search_params: ['category']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:document_reference_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end