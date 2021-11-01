require_relative '../../search_test'

module USCore
  class PediatricWeightForHeightPatientCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient + category'
    description %(
      A server SHALL support searching by patient + category on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :pediatric_weight_for_height_patient_category_search_test

    input :patient_id, default: '85'

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:pediatric_weight_for_height_resources] ||= []
    end

    def search_params
      {
        'patient': patient_id,
        'category': search_param_value('category')
      }
    end

    run do
      perform_search_test
    end
  end
end
