require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class MedicationRequestPatientIntentAuthoredonSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for MedicationRequest search by patient + intent + authoredon'
    description %(
A server SHOULD support searching by
patient + intent + authoredon on the MedicationRequest resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

If any MedicationRequest resources use external references to
Medications, the search will be repeated with
`_include=MedicationRequest:medication`.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core/STU3.1.1/CapabilityStatement-us-core-server.html)

    )

    id :medication_request_patient_intent_authoredon_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'MedicationRequest',
        search_param_names: ['patient', 'intent', 'authoredon'],
        possible_status_search: true,
        test_medication_inclusion: true,
        params_with_comparators: ['authoredon']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:medication_request_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
