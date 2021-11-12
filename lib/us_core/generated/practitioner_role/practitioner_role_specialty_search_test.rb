require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class PractitionerRoleSpecialtySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for PractitionerRole search by specialty'
    description %(
      A server SHALL support searching by specialty on the PractitionerRole resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :practitioner_role_specialty_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        first_search: true,
        resource_type: 'PractitionerRole',
        search_param_names: ['specialty'],
        saves_delayed_references: true
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:practitioner_role_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
