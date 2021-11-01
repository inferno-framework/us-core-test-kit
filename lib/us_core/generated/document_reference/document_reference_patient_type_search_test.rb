require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class DocumentReferencePatientTypeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DocumentReference search by patient + type'
    description %(
      A server SHALL support searching by patient + type on the DocumentReference resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :document_reference_patient_type_search_test

    input :patient_id, default: '85'

    def resource_type
      'DocumentReference'
    end

    def self.metadata
      @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
    end

    def scratch_resources
      scratch[:document_reference_resources] ||= []
    end

    def search_params
      {
        'patient': patient_id,
        'type': search_param_value('type')
      }
    end

    run do
      perform_search_test
    end
  end
end
