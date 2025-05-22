require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV700
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
        * Provenance.agent:ProvenanceAuthor.type
        * Provenance.agent:ProvenanceTransmitter
        * Provenance.agent:ProvenanceTransmitter.type
        * Provenance.recorded
        * Provenance.target
        * Provenance.target.reference
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@1', 'hl7.fhir.us.core_7.0.0@13',
                            'hl7.fhir.us.core_7.0.0@75', 'hl7.fhir.us.core_7.0.0@87',
                            'hl7.fhir.us.core_7.0.0@88', 'hl7.fhir.us.core_7.0.0@90',
                            'hl7.fhir.us.core_7.0.0@91'

      id :us_core_v700_provenance_must_support_test

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
