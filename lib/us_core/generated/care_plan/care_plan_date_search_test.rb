require_relative '../../search_test'

module USCore
  class CarePlanDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for CarePlan search by date'
    description %(
      A server MAY support searching by date on the CarePlan resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :care_plan_date_search_test

    def resource_type
      'CarePlan'
    end

    def scratch_resources
      scratch[:care_plan_resources] ||= []
    end

    def search_params
      {
        'date': search_param_value('period')
      }
    end

    run do
      perform_search_test
    end
  end
end
