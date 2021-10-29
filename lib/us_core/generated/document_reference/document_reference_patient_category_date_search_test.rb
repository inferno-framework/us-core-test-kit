require_relative '../../search_test'

module USCore
  class DocumentReferencePatientCategoryDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DocumentReference search by patient + category + date'
    description %(
      A server SHALL support searching by patient + category + date on the DocumentReference resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :document_reference_patient_category_date_search_test

    input :patient_id, default: '85'

    def resource_type
      'DocumentReference'
    end

    def scratch_resources
      scratch[:document_reference_resources] = [] if scratch[:document_reference_resources].nil?
      scratch[:document_reference_resources]
    end

    def search_params
      {
        'patient': patient_id,
        'category': search_param_value(find_a_value_at(scratch_resources, 'category')),
        'date': search_param_value(find_a_value_at(scratch_resources, 'date'))
      }
    end

    run do
      perform_search_test
    end
  end
end
