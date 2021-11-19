require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class MedicationRequestPatientIntentSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for MedicationRequest search by patient + intent'
    description %(
      A server SHALL support searching by patient + intent on the MedicationRequest resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :medication_request_patient_intent_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        first_search: true,
        fixed_value_search: true,
        resource_type: 'MedicationRequest',
        search_param_names: ['patient', 'intent'],
        saves_delayed_references: true,
        possible_status_search: true,
        test_medication_inclusion: true
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
