require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class PractitionerRolePractitionerSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for PractitionerRole search by practitioner'
    description %(
      A server SHALL support searching by practitioner on the PractitionerRole resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :practitioner_role_practitioner_search_test

    def resource_type
      'PractitionerRole'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:practitioner_role_resources] ||= []
    end

    def search_param_names
      ['practitioner']
    end

    run do
      perform_search_test
    end
  end
end
