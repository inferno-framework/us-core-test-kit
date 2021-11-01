require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class MedicationRequestStatusSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for MedicationRequest search by status'
    description %(
      A server MAY support searching by status on the MedicationRequest resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :medication_request_status_search_test

    def resource_type
      'MedicationRequest'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:medication_request_resources] ||= []
    end

    def search_params
      {
        'status': search_param_value('status')
      }
    end

    run do
      perform_search_test
    end
  end
end
