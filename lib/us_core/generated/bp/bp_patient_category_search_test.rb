require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class BpPatientCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient + category'
    description %(
      A server SHALL support searching by patient + category on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :bp_patient_category_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'Observation',
        search_param_names: ['patient', 'category']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:bp_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
