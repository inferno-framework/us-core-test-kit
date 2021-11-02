require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class CarePlanPatientCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for CarePlan search by patient + category'
    description %(
      A server SHALL support searching by patient + category on the CarePlan resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :care_plan_patient_category_search_test

    input :patient_id, default: '85'

    def resource_type
      'CarePlan'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:care_plan_resources] ||= []
    end

    def search_param_names
      ['patient', 'category']
    end

    run do
      perform_search_test
    end
  end
end
