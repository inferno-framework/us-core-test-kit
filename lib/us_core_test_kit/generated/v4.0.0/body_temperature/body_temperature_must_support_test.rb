require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV400
    class BodyTemperatureMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Observation resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Observation resources
        found previously for the following must support elements:

        * Observation.category
        * Observation.category.coding
        * Observation.category.coding.code
        * Observation.category.coding.system
        * Observation.category:VSCat
        * Observation.code.coding.code
        * Observation.effectiveDateTime
        * Observation.status
        * Observation.subject
        * Observation.value[x]
        * Observation.value[x].code
        * Observation.value[x].system
        * Observation.value[x].unit
        * Observation.value[x].value
        * Observation.value[x]:valueQuantity
      )

      id :us_core_v400_body_temperature_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:body_temperature_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
