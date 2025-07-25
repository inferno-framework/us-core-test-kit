require_relative '../../../reference_resolution_test'

module USCoreTestKit
  module USCoreV610
    class AllergyIntoleranceReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest

      title 'MustSupport references within AllergyIntolerance resources are valid'
      description %(
        This test will attempt to read external references provided within elements
        marked as 'MustSupport', if any are available.

        It verifies that at least one external reference for each MustSupport Reference element
        can be accessed by the test client, and conforms to corresponding US Core profile.

        Elements which may provide external references include:

        * AllergyIntolerance.patient
      )
      verifies_requirements 'hl7.fhir.us.core_6.1.0@105',
                            'hl7.fhir.us.core_6.1.0@109'

      id :us_core_v610_allergy_intolerance_reference_resolution_test

      def resource_type
        'AllergyIntolerance'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:allergy_intolerance_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
