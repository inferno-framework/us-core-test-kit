require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV800
    class AdiDocumentReferencePatientSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for DocumentReference search by patient'
      description %(
A server SHALL support searching by
patient on the DocumentReference resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/2025Jan/CapabilityStatement-us-core-server.html)

      )

      id :us_core_v800_adi_document_reference_patient_search_test
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      input :document_reference_type_codes,
        title: 'DocumentReference Type Code',
        description: %(
          Enter the code for a DocumentReference type you want to exclude, or multiple codes separated by commas.
          You can provide the system along with the code, in the format `{system|}[code]`.
          If blank, Inferno will validate all DocumentReference resources against the DocumentReference profile
        ),
        optional: true
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'DocumentReference',
        search_param_names: ['patient'],
        possible_status_search: true
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:adi_document_reference_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
