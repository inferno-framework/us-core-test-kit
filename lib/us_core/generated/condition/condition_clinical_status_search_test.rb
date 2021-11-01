require_relative '../../search_test'

module USCore
  class ConditionClinicalStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Condition search by clinical-status'
    description %(
      A server MAY support searching by clinical-status on the Condition resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :condition_clinical_status_search_test

    def resource_type
      'Condition'
    end

    def scratch_resources
      scratch[:condition_resources] ||= []
    end

    def search_params
      {
        'clinical-status': search_param_value('clinicalStatus')
      }
    end

    run do
      perform_search_test
    end
  end
end
