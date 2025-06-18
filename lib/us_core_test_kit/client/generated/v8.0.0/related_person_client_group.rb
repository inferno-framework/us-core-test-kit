# frozen_string_literal: true

require_relative 'related_person/related_person_client_read_test'
require_relative 'related_person/related_person_patient_client_search_test'
require_relative 'related_person/related_person_id_client_search_test'
require_relative 'related_person/related_person_name_client_search_test'
require_relative 'related_person/related_person_patient_name_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV800
      class RelatedPersonClientGroup < Inferno::TestGroup
        id :us_core_client_v800_related_person
        title 'RelatedPerson'
        description %(
          
# Background

This test group verifies that the client can access RelatedPerson data
conforming to the US Core RelatedPerson Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the RelatedPerson FHIR resource type. However, if they
do support it, they must support the US Core RelatedPerson Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
RelatedPerson resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-related-person`

## Searching
These tests will check that the client performed searches agains the
RelatedPerson resource type with the following required parameters:

* _id

Inferno will also look for searches using the following optional parameters:

* patient
* name
* patient + name


        )
        optional true
        run_as_group

        test from: :us_core_v800_related_person_client_read_test
        test from: :us_core_v800_related_person_patient_client_search_test
        test from: :us_core_v800_related_person_id_client_search_test
        test from: :us_core_v800_related_person_name_client_search_test
        test from: :us_core_v800_related_person_patient_name_client_search_test
      end
    end
  end
end
