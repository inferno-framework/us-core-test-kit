require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV700_BALLOT
    class MedicationDispensePatientStatusSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for MedicationDispense search by patient + status'
      description %(
A server SHOULD support searching by
patient + status on the MedicationDispense resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

If any MedicationDispense resources use external references to
Medications, the search will be repeated with
`_include=MedicationDispense:medication`.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :us_core_v700_ballot_medication_dispense_patient_status_search_test
      optional
  
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'MedicationDispense',
        search_param_names: ['patient', 'status'],
        test_medication_inclusion: true,
        multiple_or_search_params: ['status']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_dispense_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
