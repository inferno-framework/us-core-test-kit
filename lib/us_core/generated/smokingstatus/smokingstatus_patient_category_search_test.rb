require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class SmokingstatusPatientCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient + category'
    description %(
      A server SHALL support searching by patient + category on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :smokingstatus_patient_category_search_test

    input :patient_id, default: '85'

    def resource_type
      'Observation'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:smokingstatus_resources] ||= []
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
