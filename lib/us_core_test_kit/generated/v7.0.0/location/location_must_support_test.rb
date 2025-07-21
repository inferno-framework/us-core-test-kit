require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV700
    class LocationMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Location resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Location resources
        found previously for the following must support elements:

        * Location.address
        * Location.address.city
        * Location.address.line
        * Location.address.postalCode
        * Location.address.state
        * Location.identifier
        * Location.managingOrganization
        * Location.name
        * Location.status
        * Location.telecom
        * Location.type
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
                            'hl7.fhir.us.core_7.0.0@115'

      id :us_core_v700_location_must_support_test

      def resource_type
        'Location'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
