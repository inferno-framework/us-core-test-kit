require_relative '../../search_test'

module USCore
  class DocumentReferenceCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DocumentReference search by category'
    description %(
      A server MAY support searching by category on the DocumentReference resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :document_reference_category_search_test

    def resource_type
      'DocumentReference'
    end

    def scratch_resources
      scratch[:document_reference_resources] = [] if scratch[:document_reference_resources].nil?
      scratch[:document_reference_resources]
    end

    def search_params
      {
        'category': search_param_value(find_a_value_at(scratch_resources, 'category'))
      }
    end

    run do
      perform_search_test
    end
  end
end
