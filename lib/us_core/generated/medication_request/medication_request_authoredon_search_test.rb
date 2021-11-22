require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class MedicationRequestAuthoredonSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for MedicationRequest search by authoredon'
    description %(
      A server MAY support searching by authoredon on the MedicationRequest resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :medication_request_authoredon_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'MedicationRequest',
        search_param_names: ['authoredon'],
        possible_status_search: true,
        test_medication_inclusion: true,
        params_with_comparators: ['authoredon']
      )
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:medication_request_resources] ||= {}
    end

    run do
      run_search_test
    end
  end
end
