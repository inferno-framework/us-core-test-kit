require_relative '../../../must_support_test'

module USCoreTestKit
  module USCoreV600_BALLOT
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
        * Patient.address.period
        * Patient.address.postalCode
        * Patient.address.state
        * Patient.birthDate
        * Patient.gender
        * Patient.identifier
        * Patient.identifier.system
        * Patient.identifier.value
        * Patient.name
        * Patient.name.family
        * Patient.name.given

        For ONC USCDI requirements, each Patient must support the following additional elements:

        * Patient.address.use
        * Patient.communication
        * Patient.communication.language
        * Patient.deceasedDateTime
        * Patient.extension:birthsex
        * Patient.extension:ethnicity
        * Patient.extension:genderIdentity
        * Patient.extension:race
        * Patient.extension:sex-for-clinical-use
        * Patient.extension:tribalAffiliation
        * Patient.name.period.end
        * Patient.name.suffix
        * Patient.name.use
        * Patient.telecom
        * Patient.telecom.system
        * Patient.telecom.use
        * Patient.telecom.value
      )

      id :us_core_v600_ballot_patient_must_support_test

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
