require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class AllergyIntoleranceClinicalStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for AllergyIntolerance search by clinical-status'
    description %(
      A server MAY support searching by clinical-status on the AllergyIntolerance resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :allergy_intolerance_clinical_status_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'AllergyIntolerance',
        search_param_names: ['clinical-status']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:allergy_intolerance_resources] ||= []
    end

    run do
      run_search_test
    end
  end
end
