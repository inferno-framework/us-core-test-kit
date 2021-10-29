require_relative '../../search_test'

module USCore
  class EncounterPatientTypeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Encounter search by patient + type'
    description %(
      A server SHOULD support searching by patient + type on the Encounter resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :encounter_patient_type_search_test

    input :patient_id, default: '85'

    def resource_type
      'Encounter'
    end

    def scratch_resources
      scratch[:encounter_resources] = [] if scratch[:encounter_resources].nil?
      scratch[:encounter_resources]
    end

    def search_params
      {
        'patient': patient_id,
        'type': search_param_value(find_a_value_at(scratch_resources, 'type'))
      }
    end

    run do
      perform_search_test
    end
  end
end
