require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV311
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
        * Observation.code.coding:PulseOx
        * Observation.code.coding:PulseOx.code
        * Observation.code.coding:PulseOx.system
        * Observation.component
        * Observation.component.code
        * Observation.component.value[x]
        * Observation.component:Concentration
        * Observation.component:Concentration.code.coding.code
        * Observation.component:Concentration.dataAbsentReason
        * Observation.component:Concentration.value[x]
        * Observation.component:Concentration.value[x].code
        * Observation.component:Concentration.value[x].system
        * Observation.component:Concentration.value[x].unit
        * Observation.component:Concentration.value[x].value
        * Observation.component:FlowRate
        * Observation.component:FlowRate.code.coding.code
        * Observation.component:FlowRate.dataAbsentReason
        * Observation.component:FlowRate.value[x]
        * Observation.component:FlowRate.value[x].code
        * Observation.component:FlowRate.value[x].system
        * Observation.component:FlowRate.value[x].unit
        * Observation.component:FlowRate.value[x].value
        * Observation.effective[x]
        * Observation.status
        * Observation.subject
        * Observation.value[x]
        * Observation.value[x]:valueQuantity
        * Observation.value[x]:valueQuantity.code
        * Observation.value[x]:valueQuantity.system
        * Observation.value[x]:valueQuantity.unit
        * Observation.value[x]:valueQuantity.value
      )

      id :us_core_v311_pulse_oximetry_must_support_test

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
