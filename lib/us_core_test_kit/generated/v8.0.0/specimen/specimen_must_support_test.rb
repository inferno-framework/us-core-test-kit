require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV800
    class SpecimenMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Specimen resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Specimen resources
        found previously for the following must support elements:

        * Specimen.identifier or Specimen.accessionIdentifier
        * Specimen.subject
        * Specimen.type

        For ONC USCDI requirements, each Specimen must support the following additional elements:

        * Specimen.collection
        * Specimen.collection.bodySite
        * Specimen.condition
      )

      id :us_core_v800_specimen_must_support_test

      def resource_type
        'Specimen'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:specimen_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
