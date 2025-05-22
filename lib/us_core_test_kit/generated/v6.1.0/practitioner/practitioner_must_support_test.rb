require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV610
    class PractitionerMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Practitioner resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Practitioner resources
        found previously for the following must support elements:

        * Practitioner.identifier
        * Practitioner.identifier.system
        * Practitioner.identifier.value
        * Practitioner.identifier:NPI
        * Practitioner.name
        * Practitioner.name.family
        * Practitioner.telecom
        * Practitioner.telecom.system
        * Practitioner.telecom.value
      )
      verifies_requirements 'hl7.fhir.us.core_6.1.0@1', 'hl7.fhir.us.core_6.1.0@13',
                            'hl7.fhir.us.core_6.1.0@75', 'hl7.fhir.us.core_6.1.0@87',
                            'hl7.fhir.us.core_6.1.0@88', 'hl7.fhir.us.core_6.1.0@90',
                            'hl7.fhir.us.core_6.1.0@91'

      id :us_core_v610_practitioner_must_support_test

      def resource_type
        'Practitioner'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
