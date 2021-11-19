require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class AllergyIntolerancePatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for AllergyIntolerance search by patient'
    description %(
      A server SHALL support searching by patient on the AllergyIntolerance resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :allergy_intolerance_patient_search_test

    input :patient_ids,
      title: 'Patient IDs',
      description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
      default: '85,355'

    def properties
      @properties ||= SearchTestProperties.new(
        first_search: true,
        resource_type: 'AllergyIntolerance',
        search_param_names: ['patient'],
        test_reference_variants: true
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:allergy_intolerance_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
