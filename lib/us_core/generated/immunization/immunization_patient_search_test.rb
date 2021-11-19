require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class ImmunizationPatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Immunization search by patient'
    description %(
      A server SHALL support searching by patient on the Immunization resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :immunization_patient_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        first_search: true,
        resource_type: 'Immunization',
        search_param_names: ['patient'],
        possible_status_search: true,
        test_reference_variants: true
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:immunization_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
