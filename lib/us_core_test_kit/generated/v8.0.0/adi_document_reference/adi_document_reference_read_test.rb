require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV800
    class AdiDocumentReferenceReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct DocumentReference resource from DocumentReference read interaction'
      description 'A server SHALL support the DocumentReference read interaction.'

      id :us_core_v800_adi_document_reference_read_test

      def resource_type
        'DocumentReference'
      end

      def scratch_resources
        scratch[:adi_document_reference_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
