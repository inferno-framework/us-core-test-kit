require_relative '../../search_test'

module USCore
  class ProcedurePatientCodeDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Procedure search by patient + code + date'
    description %(
      A server SHOULD support searching by patient + code + date on the Procedure resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :procedure_patient_code_date_search_test

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
        'code': search_param_value('code'),
        'date': search_param_value('performed')
      }
    end

    run do
      perform_search_test
    end
  end
end
