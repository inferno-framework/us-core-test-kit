require_relative '../../../reference_resolution_test'

module USCoreTestKit
  module USCoreV700
    class MedicationRequestReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest

      title 'MustSupport references within MedicationRequest resources are valid'
      description %(
        This test will attempt to read external references provided within elements
        marked as 'MustSupport', if any are available.

        It verifies that at least one external reference for each MustSupport Reference element
        can be accessed by the test client, and conforms to corresponding US Core profile.

        Elements which may provide external references include:

        * MedicationRequest.encounter
        * MedicationRequest.medication[x]
        * MedicationRequest.reasonReference
        * MedicationRequest.reportedReference
        * MedicationRequest.requester
        * MedicationRequest.subject
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@105', 'hl7.fhir.us.core_7.0.0@109'

      id :us_core_v700_medication_request_reference_resolution_test

      def resource_type
        'MedicationRequest'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_request_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
