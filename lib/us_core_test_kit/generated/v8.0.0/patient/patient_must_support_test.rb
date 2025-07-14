require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV800
    class PatientMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Patient resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Patient resources
        found previously for the following must support elements:

        * Patient.address
        * Patient.address.city
        * Patient.address.line
        * Patient.address.postalCode
        * Patient.address.state
        * Patient.birthDate
        * Patient.identifier
        * Patient.identifier.system
        * Patient.identifier.value
        * Patient.name
        * Patient.name.family
        * Patient.name.given

        For ONC USCDI requirements, each Patient must support the following additional elements:

        * Patient.address.period.end or Patient.address.use
        * Patient.communication
        * Patient.communication.language
        * Patient.deceasedDateTime
        * Patient.extension:ethnicity
        * Patient.extension:race
        * Patient.extension:sex
        * Patient.extension:tribalAffiliation
        * Patient.name.period.end or Patient.name.use
        * Patient.name.suffix
        * Patient.telecom
        * Patient.telecom.system
        * Patient.telecom.use
        * Patient.telecom.value
      )
      verifies_requirements 'hl7.fhir.us.core_8.0.0@1',
                            'hl7.fhir.us.core_8.0.0@13',
                            'hl7.fhir.us.core_8.0.0@75',
                            'hl7.fhir.us.core_8.0.0@87',
                            'hl7.fhir.us.core_8.0.0@88',
                            'hl7.fhir.us.core_8.0.0@90',
                            'hl7.fhir.us.core_8.0.0@91',
                            'hl7.fhir.us.core_8.0.0@111',
                            'hl7.fhir.us.core_8.0.0@115',
                            'hl7.fhir.us.core_8.0.0@801',
                            'hl7.fhir.us.core_8.0.0@802',
                            'hl7.fhir.us.core_8.0.0@803',
                            'hl7.fhir.us.core_8.0.0@804',
                            'hl7.fhir.us.core_8.0.0@805',
                            'hl7.fhir.us.core_8.0.0@812',
                            'hl7.fhir.us.core_8.0.0@814',
                            'hl7.fhir.us.core_8.0.0@870',
                            'hl7.fhir.us.core_8.0.0@872'

      id :us_core_v800_patient_must_support_test

      def resource_type
        'Patient'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:patient_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
