require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV800
    class MedicationRequestPatientIntentStatusSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for MedicationRequest search by patient + intent + status'
      description %(
A server SHALL support searching by
patient + intent + status on the MedicationRequest resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

If any MedicationRequest resources use external references to
Medications, the search will be repeated with
`_include=MedicationRequest:medication`.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU8/CapabilityStatement-us-core-server.html)

      )
      verifies_requirements 'hl7.fhir.us.core_8.0.0@51',
                            'hl7.fhir.us.core_8.0.0@52',
                            'hl7.fhir.us.core_8.0.0@55',
                            'hl7.fhir.us.core_8.0.0@58',
                            'hl7.fhir.us.core_8.0.0@250',
                            'hl7.fhir.us.core_8.0.0@820'

      id :us_core_v800_medication_request_patient_intent_status_search_test
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'MedicationRequest',
        search_param_names: ['patient', 'intent', 'status'],
        test_medication_inclusion: true,
        multiple_or_search_params: ['intent', 'status']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_request_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
