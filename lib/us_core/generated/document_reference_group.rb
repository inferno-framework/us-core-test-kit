require_relative 'document_reference/document_reference_read_test'

module USCore
  class DocumentReferenceGroup < Inferno::TestGroup
    title 'DocumentReference Tests'
    # description ''

    id :document_reference

    test from: :document_reference_read_test
  end
end
