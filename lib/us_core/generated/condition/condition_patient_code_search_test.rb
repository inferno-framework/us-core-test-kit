require_relative '../../search_test'

module USCore
  class ConditionPatientCodeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Condition search by patient + code'
    description %(
      A server SHOULD support searching by patient + code on the Condition resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :condition_patient_code_search_test

    input :patient_id, default: '85'

    def resource_type
      'Condition'
    end

    def scratch_resources
      scratch[:condition_resources] ||= []
    end

    def search_params
      {
        'patient': patient_id,
        'code': search_param_value('code')
      }
    end

    run do
      perform_search_test
    end
  end
end
