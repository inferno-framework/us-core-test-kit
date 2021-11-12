require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class PatientIdSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Patient search by _id'
    description %(
      A server SHALL support searching by _id on the Patient resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :patient__id_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        first_search: true,
        resource_type: 'Patient',
        search_param_names: ['_id']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:patient_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
