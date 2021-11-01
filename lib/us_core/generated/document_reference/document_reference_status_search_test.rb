require_relative '../../search_test'

module USCore
  class DocumentReferenceStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DocumentReference search by status'
    description %(
      A server MAY support searching by status on the DocumentReference resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :document_reference_status_search_test

    def resource_type
      'DocumentReference'
    end

    def scratch_resources
      scratch[:document_reference_resources] ||= []
    end

    def search_params
      {
        'status': search_param_value('status')
      }
    end

    run do
      perform_search_test
    end
  end
end
