require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV311
    class ProvenanceMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Provenance resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Provenance resources
        found previously for the following must support elements:

        * Provenance.agent
        * Provenance.agent.onBehalfOf
        * Provenance.agent.type
        * Provenance.agent.who
        * Provenance.agent:ProvenanceAuthor
        * Provenance.agent:ProvenanceAuthor.type.coding.code
        * Provenance.agent:ProvenanceTransmitter
        * Provenance.agent:ProvenanceTransmitter.type.coding.code
        * Provenance.recorded
        * Provenance.target
      )

      id :us_core_v311_provenance_must_support_test

      def resource_type
        'Provenance'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:provenance_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
