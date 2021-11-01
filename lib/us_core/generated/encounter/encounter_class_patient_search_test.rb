require_relative '../../search_test'

module USCore
  class EncounterClassPatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Encounter search by class + patient'
    description %(
      A server SHOULD support searching by class + patient on the Encounter resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :encounter_class_patient_search_test

    input :patient_id, default: '85'

    def resource_type
      'Encounter'
    end

    def scratch_resources
      scratch[:encounter_resources] ||= []
    end

    def search_params
      {
        'class': search_param_value('local_class'),
        'patient': patient_id
      }
    end

    run do
      perform_search_test
    end
  end
end
