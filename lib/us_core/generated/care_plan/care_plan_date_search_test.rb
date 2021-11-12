require_relative '../../search_test'
require_relative '../../generator/group_metadata'

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

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'CarePlan',
        search_param_names: ['date']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:care_plan_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
