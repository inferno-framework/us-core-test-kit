require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV610
    class CarePlanMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the CarePlan resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the CarePlan resources
        found previously for the following must support elements:

        * CarePlan.category
        * CarePlan.category:AssessPlan
        * CarePlan.intent
        * CarePlan.status
        * CarePlan.subject
        * CarePlan.text
        * CarePlan.text.div
        * CarePlan.text.status
      )
      verifies_requirements 'hl7.fhir.us.core_6.1.0@1',
                            'hl7.fhir.us.core_6.1.0@13',
                            'hl7.fhir.us.core_6.1.0@75',
                            'hl7.fhir.us.core_6.1.0@87',
                            'hl7.fhir.us.core_6.1.0@90',
                            'hl7.fhir.us.core_6.1.0@91',
                            'hl7.fhir.us.core_6.1.0@93',
                            'hl7.fhir.us.core_6.1.0@94',
                            'hl7.fhir.us.core_6.1.0@97',
                            'hl7.fhir.us.core_6.1.0@99',
                            'hl7.fhir.us.core_6.1.0@111',
                            'hl7.fhir.us.core_6.1.0@115'

      id :us_core_v610_care_plan_must_support_test

      def resource_type
        'CarePlan'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:care_plan_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
