# frozen_string_literal: true

require_relative 'practitioner/practitioner_client_read_test'
require_relative 'practitioner/practitioner_client_support_test'
require_relative 'practitioner/practitioner_id_client_search_test'
require_relative 'practitioner/practitioner_identifier_client_search_test'
require_relative 'practitioner/practitioner_name_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class PractitionerClientGroup < Inferno::TestGroup
        id :us_core_client_v700_practitioner
        title 'Practitioner'
        description %(
          
# Background

This test group verifies that the client can access Practitioner data
conforming to the US Core Practitioner Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Practitioner FHIR resource type. However, if they
do support it, they must support the US Core Practitioner Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Practitioner resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-practitioner`

## Searching
These tests will check that the client performed searches agains the
Practitioner resource type with the following required parameters:

* identifier
* name

Inferno will also look for searches using the following optional parameters:

* _id


        )
        optional true
        run_as_group

        test from: :us_core_v700_practitioner_client_support_test
        test from: :us_core_v700_practitioner_client_read_test
        test from: :us_core_v700_practitioner_id_client_search_test
        test from: :us_core_v700_practitioner_identifier_client_search_test
        test from: :us_core_v700_practitioner_name_client_search_test
      end
    end
  end
end
