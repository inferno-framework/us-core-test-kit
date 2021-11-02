require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ProcedureDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Procedure search by date'
    description %(
      A server MAY support searching by date on the Procedure resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :procedure_date_search_test

    def resource_type
      'Procedure'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:procedure_resources] ||= []
    end

    def search_param_names
      ['date']
    end

    run do
      perform_search_test
    end
  end
end
