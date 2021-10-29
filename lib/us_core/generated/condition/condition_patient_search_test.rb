require_relative '../../search_test'

module USCore
  class ConditionPatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Condition search by patient'
    description %(
      A server SHALL support searching by patient on the Condition resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :condition_patient_search_test

    input :patient_id, default: '85'

    def resource_type
      'Condition'
    end

    def scratch_resources
      scratch[:condition_resources] = [] if scratch[:condition_resources].nil?
      scratch[:condition_resources]
    end

    def search_params
      {
        'patient': patient_id
      }
    end

    run do
      perform_search_test
    end
  end
end
