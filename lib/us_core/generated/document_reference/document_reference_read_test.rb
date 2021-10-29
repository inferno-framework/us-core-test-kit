require_relative '../../read_test'

module USCore
  class DocumentReferenceReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct DocumentReference resource from DocumentReference read interaction'
    description 'A server SHALL support the DocumentReference read interaction.'

    id :document_reference_read_test

    def resource_type
      'DocumentReference'
    end

    run do
      perform_read_test(scratch[:document_reference_resources])
    end
  end
end
