require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV400
    class BloodPressureMustSupportTest < Inferno::Test
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
      * Observation.component
      * Observation.component.code
      * Observation.component.code.coding.code
      * Observation.component.code.coding.code
      * Observation.component.value[x]
      * Observation.component.value[x].code
      * Observation.component.value[x].system
      * Observation.component.value[x].unit
      * Observation.component.value[x].value
      * Observation.component:diastolic
      * Observation.component:systolic
      * Observation.effective[x]
      * Observation.status
      * Observation.subject
      )

      id :us_core_v400_blood_pressure_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def scratch_resources
        scratch[:blood_pressure_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
