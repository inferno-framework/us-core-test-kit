# frozen_string_literal: true

require_relative 'bodytemp/bodytemp_client_read_test'
require_relative 'bodytemp/bodytemp_patient_code_client_search_test'
require_relative 'bodytemp/bodytemp_status_client_search_test'
require_relative 'bodytemp/bodytemp_category_client_search_test'
require_relative 'bodytemp/bodytemp_code_client_search_test'
require_relative 'bodytemp/bodytemp_date_client_search_test'
require_relative 'bodytemp/bodytemp_patient_client_search_test'
require_relative 'bodytemp/bodytemp_patient_category_date_client_search_test'
require_relative 'bodytemp/bodytemp_patient_category_status_client_search_test'
require_relative 'bodytemp/bodytemp_patient_code_date_client_search_test'
require_relative 'bodytemp/bodytemp_patient_category_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class BodytempClientGroup < Inferno::TestGroup
        id :us_core_client_v311_bodytemp
        title 'Observation Body Temperature'
        description %(
          
# Background

This test group verifies that the client can access Observation data
conforming to the Observation Body Temperature Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Observation FHIR resource type. However, if they
do support it, they must support the Observation Body Temperature Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Observation resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-bodytemp`

## Searching
These tests will check that the client performed searches agains the
Observation resource type with the following required parameters:



Inferno will also look for searches using the following optional parameters:

* patient + code
* status
* category
* code
* date
* patient
* patient + category + date
* patient + category + status
* patient + code + date
* patient + category


        )
        optional true
        run_as_group

        test from: :us_core_v311_bodytemp_client_read_test
        test from: :us_core_v311_bodytemp_patient_code_client_search_test
        test from: :us_core_v311_bodytemp_status_client_search_test
        test from: :us_core_v311_bodytemp_category_client_search_test
        test from: :us_core_v311_bodytemp_code_client_search_test
        test from: :us_core_v311_bodytemp_date_client_search_test
        test from: :us_core_v311_bodytemp_patient_client_search_test
        test from: :us_core_v311_bodytemp_patient_category_date_client_search_test
        test from: :us_core_v311_bodytemp_patient_category_status_client_search_test
        test from: :us_core_v311_bodytemp_patient_code_date_client_search_test
        test from: :us_core_v311_bodytemp_patient_category_client_search_test
      end
    end
  end
end
