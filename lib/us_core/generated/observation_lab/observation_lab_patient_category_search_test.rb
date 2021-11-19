require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ObservationLabPatientCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient + category'
    description %(
      A server SHALL support searching by patient + category on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :observation_lab_patient_category_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        first_search: true,
        fixed_value_search: true,
        resource_type: 'Observation',
        search_param_names: ['patient', 'category'],
        possible_status_search: true,
        token_search_params: ['category']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:observation_lab_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
