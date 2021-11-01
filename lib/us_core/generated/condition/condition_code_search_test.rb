require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ConditionCodeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Condition search by code'
    description %(
      A server MAY support searching by code on the Condition resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :condition_code_search_test

    def resource_type
      'Condition'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:condition_resources] ||= []
    end

    def search_params
      {
        'code': search_param_value('code')
      }
    end

    run do
      perform_search_test
    end
  end
end
