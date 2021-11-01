require_relative '../../search_test'

module USCore
  class DocumentReferencePeriodSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DocumentReference search by period'
    description %(
      A server MAY support searching by period on the DocumentReference resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :document_reference_period_search_test

    def resource_type
      'DocumentReference'
    end

    def scratch_resources
      scratch[:document_reference_resources] ||= []
    end

    def search_params
      {
        'period': search_param_value('context.period')
      }
    end

    run do
      perform_search_test
    end
  end
end
