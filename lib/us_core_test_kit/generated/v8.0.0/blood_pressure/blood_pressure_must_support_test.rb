require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV800
    class BloodPressureMustSupportTest < Inferno::Test
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
        * Observation.code.coding.code
        * Observation.component
        * Observation.component.code
        * Observation.component.dataAbsentReason
        * Observation.component.valueQuantity
        * Observation.component:diastolic
        * Observation.component:diastolic.code
        * Observation.component:diastolic.dataAbsentReason
        * Observation.component:diastolic.valueQuantity
        * Observation.component:diastolic.valueQuantity.code
        * Observation.component:diastolic.valueQuantity.system
        * Observation.component:diastolic.valueQuantity.unit
        * Observation.component:diastolic.valueQuantity.value
        * Observation.component:systolic
        * Observation.component:systolic.code
        * Observation.component:systolic.dataAbsentReason
        * Observation.component:systolic.valueQuantity
        * Observation.component:systolic.valueQuantity.code
        * Observation.component:systolic.valueQuantity.system
        * Observation.component:systolic.valueQuantity.unit
        * Observation.component:systolic.valueQuantity.value
        * Observation.effectiveDateTime
        * Observation.performer
        * Observation.status
        * Observation.subject
      )
      verifies_requirements 'hl7.fhir.us.core_8.0.0@1',
                            'hl7.fhir.us.core_8.0.0@13',
                            'hl7.fhir.us.core_8.0.0@75',
                            'hl7.fhir.us.core_8.0.0@87',
                            'hl7.fhir.us.core_8.0.0@90',
                            'hl7.fhir.us.core_8.0.0@91',
                            'hl7.fhir.us.core_8.0.0@93',
                            'hl7.fhir.us.core_8.0.0@94',
                            'hl7.fhir.us.core_8.0.0@97',
                            'hl7.fhir.us.core_8.0.0@99',
                            'hl7.fhir.us.core_8.0.0@111',
                            'hl7.fhir.us.core_8.0.0@115',
                            'hl7.fhir.us.core_8.0.0@801',
                            'hl7.fhir.us.core_8.0.0@802',
                            'hl7.fhir.us.core_8.0.0@803',
                            'hl7.fhir.us.core_8.0.0@804',
                            'hl7.fhir.us.core_8.0.0@805',
                            'hl7.fhir.us.core_8.0.0@812',
                            'hl7.fhir.us.core_8.0.0@814',
                            'hl7.fhir.us.core_8.0.0@872'

      id :us_core_v800_blood_pressure_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
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
