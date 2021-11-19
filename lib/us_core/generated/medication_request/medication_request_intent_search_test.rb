require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class MedicationRequestIntentSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for MedicationRequest search by intent'
    description %(
      A server MAY support searching by intent on the MedicationRequest resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :medication_request_intent_search_test

    def properties
      @properties ||= SearchTestProperties.new(
        resource_type: 'MedicationRequest',
        search_param_names: ['intent'],
        possible_status_search: true,
        test_medication_inclusion: true
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
