require_relative 'document_reference/document_reference_patient_search_test'
require_relative 'document_reference/document_reference_id_search_test'
require_relative 'document_reference/document_reference_status_search_test'
require_relative 'document_reference/document_reference_category_search_test'
require_relative 'document_reference/document_reference_type_search_test'
require_relative 'document_reference/document_reference_date_search_test'
require_relative 'document_reference/document_reference_period_search_test'
require_relative 'document_reference/document_reference_patient_type_period_search_test'
require_relative 'document_reference/document_reference_patient_type_search_test'
require_relative 'document_reference/document_reference_patient_category_date_search_test'
require_relative 'document_reference/document_reference_patient_status_search_test'
require_relative 'document_reference/document_reference_patient_category_search_test'
require_relative 'document_reference/document_reference_read_test'

module USCore
  class DocumentReferenceGroup < Inferno::TestGroup
    title 'DocumentReference Tests'
    # description ''

    id :document_reference

    test from: :document_reference_patient_search_test
    test from: :document_reference__id_search_test
    test from: :document_reference_status_search_test
    test from: :document_reference_category_search_test
    test from: :document_reference_type_search_test
    test from: :document_reference_date_search_test
    test from: :document_reference_period_search_test
    test from: :document_reference_patient_type_period_search_test
    test from: :document_reference_patient_type_search_test
    test from: :document_reference_patient_category_date_search_test
    test from: :document_reference_patient_status_search_test
    test from: :document_reference_patient_category_search_test
    test from: :document_reference_read_test
  end
end
