require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV700
    class ProcedureMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Procedure resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Procedure resources
        found previously for the following must support elements:

        * Procedure.code
        * Procedure.encounter
        * Procedure.performedDateTime
        * Procedure.status
        * Procedure.subject

        For ONC USCDI requirements, each Procedure must support the following additional elements:

        * Procedure.basedOn
        * Procedure.reasonCode or Procedure.reasonReference
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@1',
                            'hl7.fhir.us.core_7.0.0@13',
                            'hl7.fhir.us.core_7.0.0@75',
                            'hl7.fhir.us.core_7.0.0@87',
                            'hl7.fhir.us.core_7.0.0@90',
                            'hl7.fhir.us.core_7.0.0@91',
                            'hl7.fhir.us.core_7.0.0@93',
                            'hl7.fhir.us.core_7.0.0@94',
                            'hl7.fhir.us.core_7.0.0@97',
                            'hl7.fhir.us.core_7.0.0@99',
                            'hl7.fhir.us.core_7.0.0@111',
                            'hl7.fhir.us.core_7.0.0@115',
                            'hl7.fhir.us.core_7.0.0@482',
                            'hl7.fhir.us.core_7.0.0@484'

      id :us_core_v700_procedure_must_support_test

      def resource_type
        'Procedure'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:procedure_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
