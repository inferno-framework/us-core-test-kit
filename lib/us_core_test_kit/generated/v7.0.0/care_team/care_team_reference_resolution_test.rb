require_relative '../../../reference_resolution_test'

module USCoreTestKit
  module USCoreV700
    class CareTeamReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest

      title 'MustSupport references within CareTeam resources are valid'
      description %(
        This test will attempt to read external references provided within elements
        marked as 'MustSupport', if any are available.

        It verifies that at least one external reference for each MustSupport Reference element
        can be accessed by the test client, and conforms to corresponding US Core profile.

        Elements which may provide external references include:

        * CareTeam.participant.member
        * CareTeam.subject
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@105',
                            'hl7.fhir.us.core_7.0.0@109',
                            'hl7.fhir.us.core_7.0.0@313'

      id :us_core_v700_care_team_reference_resolution_test

      def resource_type
        'CareTeam'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:care_team_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
