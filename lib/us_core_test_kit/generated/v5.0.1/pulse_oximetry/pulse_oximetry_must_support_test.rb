require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV501
    class PulseOximetryMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Observation resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Observation resources
        found previously for the following must support elements:

        * Observation.category
        * Observation.category:VSCat
        * Observation.category:VSCat.coding
        * Observation.category:VSCat.coding.code
        * Observation.category:VSCat.coding.system
        * Observation.code
        * Observation.code.coding
        * Observation.code.coding:O2Sat
        * Observation.code.coding:PulseOx
        * Observation.component
        * Observation.component.code
        * Observation.component.valueQuantity
        * Observation.component:Concentration
        * Observation.component:Concentration.code
        * Observation.component:Concentration.valueQuantity
        * Observation.component:Concentration.valueQuantity.code
        * Observation.component:Concentration.valueQuantity.system
        * Observation.component:Concentration.valueQuantity.unit
        * Observation.component:Concentration.valueQuantity.value
        * Observation.component:FlowRate
        * Observation.component:FlowRate.code
        * Observation.component:FlowRate.valueQuantity
        * Observation.component:FlowRate.valueQuantity.code
        * Observation.component:FlowRate.valueQuantity.system
        * Observation.component:FlowRate.valueQuantity.unit
        * Observation.component:FlowRate.valueQuantity.value
        * Observation.effectiveDateTime
        * Observation.status
        * Observation.subject
        * Observation.valueQuantity
      )

      id :us_core_v501_pulse_oximetry_must_support_test

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
