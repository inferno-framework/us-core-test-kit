require_relative '../../search_test'

module USCore
  class DocumentReferencePatientStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DocumentReference search by patient + status'
    description %(
      A server SHOULD support searching by patient + status on the DocumentReference resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :document_reference_patient_status_search_test

    input :patient_id, default: '85'

    def resource_type
      'DocumentReference'
    end

    def scratch_resources
      scratch[:document_reference_resources] = [] if scratch[:document_reference_resources].nil?
      scratch[:document_reference_resources]
    end

    def search_params
      {
        'patient': patient_id,
        'status': search_param_value(find_a_value_at(scratch_resources, 'status'))
      }
    end

    run do
      perform_search_test
    end
  end
end
