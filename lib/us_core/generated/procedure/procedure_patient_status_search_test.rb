require_relative '../../search_test'

module USCore
  class ProcedurePatientStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Procedure search by patient + status'
    description %(
      A server SHOULD support searching by patient + status on the Procedure resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :procedure_patient_status_search_test

    input :patient_id, default: '85'

    def resource_type
      'Procedure'
    end

    def scratch_resources
      scratch[:procedure_resources] ||= []
    end

    def search_params
      {
        'patient': patient_id,
        'status': search_param_value('status')
      }
    end

    run do
      perform_search_test
    end
  end
end
