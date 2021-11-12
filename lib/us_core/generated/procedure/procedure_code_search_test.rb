require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ProcedureCodeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Procedure search by code'
    description %(
      A server MAY support searching by code on the Procedure resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :procedure_code_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Procedure',
        search_param_names: ['code']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:procedure_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
