require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ConditionPatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Condition search by patient'
    description %(
      A server SHALL support searching by patient on the Condition resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :condition_patient_search_test

    input :patient_id, default: '85'

    def properties
      @properties ||= SearchTestProperties.new(
        first_search: true,
        resource_type: 'Condition',
        search_param_names: ['patient']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:condition_resources] ||= []
    end

    run do
      run_search_test
    end
  end
end
