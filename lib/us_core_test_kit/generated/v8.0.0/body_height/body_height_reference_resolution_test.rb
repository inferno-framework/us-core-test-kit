require_relative '../../../reference_resolution_test'

module USCoreTestKit
  module USCoreV800
    class BodyHeightReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest

      title 'MustSupport references within Observation resources are valid'
      description %(
        This test will attempt to read external references provided within elements
        marked as 'MustSupport', if any are available.

        It verifies that at least one external reference for each MustSupport Reference element
        can be accessed by the test client, and conforms to corresponding US Core profile.

        Elements which may provide external references include:

        * Observation.performer
        * Observation.subject
      )
      verifies_requirements 'hl7.fhir.us.core_8.0.0@105',
                            'hl7.fhir.us.core_8.0.0@109',
                            'hl7.fhir.us.core_8.0.0@808',
                            'hl7.fhir.us.core_8.0.0@809',
                            'hl7.fhir.us.core_8.0.0@810',
                            'hl7.fhir.us.core_8.0.0@811'

      id :us_core_v800_body_height_reference_resolution_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:body_height_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
