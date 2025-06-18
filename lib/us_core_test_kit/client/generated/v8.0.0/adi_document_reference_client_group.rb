# frozen_string_literal: true

require_relative 'adi_document_reference/adi_document_reference_client_read_test'
require_relative 'adi_document_reference/adi_document_reference_patient_category_client_search_test'
require_relative 'adi_document_reference/adi_document_reference_id_client_search_test'
require_relative 'adi_document_reference/adi_document_reference_patient_client_search_test'
require_relative 'adi_document_reference/adi_document_reference_patient_status_client_search_test'
require_relative 'adi_document_reference/adi_document_reference_patient_category_date_client_search_test'
require_relative 'adi_document_reference/adi_document_reference_patient_type_period_client_search_test'
require_relative 'adi_document_reference/adi_document_reference_patient_type_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV800
      class AdiDocumentReferenceClientGroup < Inferno::TestGroup
        id :us_core_client_v800_adi_document_reference
        title 'DocumentReference ADI'
        description %(
          
# Background

This test group verifies that the client can access DocumentReference data
conforming to the US Core ADI DocumentReference Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the DocumentReference FHIR resource type. However, if they
do support it, they must support the US Core ADI DocumentReference Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
DocumentReference resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-adi-document-reference`

## Searching
These tests will check that the client performed searches agains the
DocumentReference resource type with the following required parameters:

* patient + category
* _id
* patient
* patient + category + date
* patient + type

Inferno will also look for searches using the following optional parameters:

* patient + status
* patient + type + period


        )
        optional true
        run_as_group

        test from: :us_core_v800_adi_document_reference_client_read_test
        test from: :us_core_v800_adi_document_reference_patient_category_client_search_test
        test from: :us_core_v800_adi_document_reference_id_client_search_test
        test from: :us_core_v800_adi_document_reference_patient_client_search_test
        test from: :us_core_v800_adi_document_reference_patient_status_client_search_test
        test from: :us_core_v800_adi_document_reference_patient_category_date_client_search_test
        test from: :us_core_v800_adi_document_reference_patient_type_period_client_search_test
        test from: :us_core_v800_adi_document_reference_patient_type_client_search_test
      end
    end
  end
end
