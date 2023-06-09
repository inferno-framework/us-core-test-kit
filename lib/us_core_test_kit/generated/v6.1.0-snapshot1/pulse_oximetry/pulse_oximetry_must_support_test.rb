require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV610_SNAPSHOT1
    class PulseOximetryMustSupportTest < Inferno::Test
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
        * Observation.code
        * Observation.code.coding
        * Observation.code.coding:O2Sat
        * Observation.code.coding:PulseOx
        * Observation.component
        * Observation.component.code
        * Observation.component.code.coding.code
        * Observation.component.valueQuantity
        * Observation.component.valueQuantity.code
        * Observation.component.valueQuantity.system
        * Observation.component.valueQuantity.unit
        * Observation.component.valueQuantity.value
        * Observation.component:Concentration
        * Observation.component:FlowRate
        * Observation.effectiveDateTime
        * Observation.status
        * Observation.subject
        * Observation.valueQuantity
        * Observation.valueQuantity.code
        * Observation.valueQuantity.system
        * Observation.valueQuantity.unit
        * Observation.valueQuantity.value
        * Observation.value[x]:valueQuantity
      )

      id :us_core_v610_snapshot1_pulse_oximetry_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:pulse_oximetry_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
