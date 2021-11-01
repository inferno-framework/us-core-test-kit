require_relative '../../search_test'
require_relative '../../generator/group_metadata'

module USCore
  class DocumentReferenceIdSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DocumentReference search by _id'
    description %(
      A server SHALL support searching by _id on the DocumentReference resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :document_reference__id_search_test

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
        '_id': search_param_value('id')
      }
    end

    run do
      perform_search_test
    end
  end
end
