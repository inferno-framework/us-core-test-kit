# frozen_string_literal: true

require_relative 'document_reference/document_reference_client_read_test'
require_relative 'document_reference/document_reference_patient_client_search_test'
require_relative 'document_reference/document_reference_id_client_search_test'
require_relative 'document_reference/document_reference_patient_category_client_search_test'
require_relative 'document_reference/document_reference_patient_type_client_search_test'
require_relative 'document_reference/document_reference_patient_category_date_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class DocumentReferenceClientGroup < Inferno::TestGroup
        id :us_core_client_v400_document_reference

        title 'DocumentReference'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required DocumentReference queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-document-reference`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient
* _id
* patient + category
* patient + type
* patient + category + date

        )

        run_as_group

        test from: :us_core_v400_document_reference_client_read_test
        test from: :us_core_v400_document_reference_patient_client_search_test
        test from: :us_core_v400_document_reference_id_client_search_test
        test from: :us_core_v400_document_reference_patient_category_client_search_test
        test from: :us_core_v400_document_reference_patient_type_client_search_test
        test from: :us_core_v400_document_reference_patient_category_date_client_search_test
      end
    end
  end
end
