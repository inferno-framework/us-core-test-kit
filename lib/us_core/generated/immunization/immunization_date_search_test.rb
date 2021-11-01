require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ImmunizationDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Immunization search by date'
    description %(
      A server MAY support searching by date on the Immunization resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :immunization_date_search_test

    def resource_type
      'Immunization'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:immunization_resources] ||= []
    end

    def search_params
      {
        'date': search_param_value('occurrence')
      }
    end

    run do
      perform_search_test
    end
  end
end
