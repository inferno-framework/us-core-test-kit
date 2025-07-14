require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV700
    class CoverageMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Coverage resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Coverage resources
        found previously for the following must support elements:

        * Coverage.beneficiary
        * Coverage.class
        * Coverage.class:group
        * Coverage.class:group.value
        * Coverage.class:plan
        * Coverage.class:plan.name
        * Coverage.class:plan.value
        * Coverage.identifier
        * Coverage.identifier:memberid
        * Coverage.identifier:memberid.type
        * Coverage.payor
        * Coverage.period
        * Coverage.relationship
        * Coverage.status
        * Coverage.subscriberId
        * Coverage.type
      )
      verifies_requirements 'hl7.fhir.us.core_7.0.0@1',
                            'hl7.fhir.us.core_7.0.0@13',
                            'hl7.fhir.us.core_7.0.0@75',
                            'hl7.fhir.us.core_7.0.0@87',
                            'hl7.fhir.us.core_7.0.0@88',
                            'hl7.fhir.us.core_7.0.0@90',
                            'hl7.fhir.us.core_7.0.0@91',
                            'hl7.fhir.us.core_7.0.0@111',
                            'hl7.fhir.us.core_7.0.0@115'

      id :us_core_v700_coverage_must_support_test

      def resource_type
        'Coverage'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:coverage_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
