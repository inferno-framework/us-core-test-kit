require_relative '../../search_test'

module USCore
  class ConditionOnsetDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Condition search by onset-date'
    description %(
      A server MAY support searching by onset-date on the Condition resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :condition_onset_date_search_test

    def resource_type
      'Condition'
    end

    def scratch_resources
      scratch[:condition_resources] ||= []
    end

    def search_params
      {
        'onset-date': search_param_value('onsetDateTime')
      }
    end

    run do
      perform_search_test
    end
  end
end
