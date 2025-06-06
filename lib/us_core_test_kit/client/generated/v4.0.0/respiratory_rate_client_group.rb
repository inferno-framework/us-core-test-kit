# frozen_string_literal: true

require_relative 'respiratory_rate/respiratory_rate_client_read_test'
require_relative 'respiratory_rate/respiratory_rate_client_support_test'
require_relative 'respiratory_rate/respiratory_rate_patient_code_client_search_test'
require_relative 'respiratory_rate/respiratory_rate_status_client_search_test'
require_relative 'respiratory_rate/respiratory_rate_category_client_search_test'
require_relative 'respiratory_rate/respiratory_rate_code_client_search_test'
require_relative 'respiratory_rate/respiratory_rate_date_client_search_test'
require_relative 'respiratory_rate/respiratory_rate_patient_client_search_test'
require_relative 'respiratory_rate/respiratory_rate_patient_category_status_client_search_test'
require_relative 'respiratory_rate/respiratory_rate_patient_code_date_client_search_test'
require_relative 'respiratory_rate/respiratory_rate_patient_category_date_client_search_test'
require_relative 'respiratory_rate/respiratory_rate_patient_category_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class RespiratoryRateClientGroup < Inferno::TestGroup
        id :us_core_client_v400_respiratory_rate
        title 'Observation Respiratory Rate'
        description %(
          
# Background

This test group verifies that the client can access Observation data
conforming to the US Core Respiratory Rate Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Observation FHIR resource type. However, if they
do support it, they must support the US Core Respiratory Rate Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Observation resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-respiratory-rate`

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
* patient + category + status
* patient + code + date
* patient + category + date
* patient + category


        )
        optional true
        run_as_group

        test from: :us_core_v400_respiratory_rate_client_support_test
        test from: :us_core_v400_respiratory_rate_client_read_test
        test from: :us_core_v400_respiratory_rate_patient_code_client_search_test
        test from: :us_core_v400_respiratory_rate_status_client_search_test
        test from: :us_core_v400_respiratory_rate_category_client_search_test
        test from: :us_core_v400_respiratory_rate_code_client_search_test
        test from: :us_core_v400_respiratory_rate_date_client_search_test
        test from: :us_core_v400_respiratory_rate_patient_client_search_test
        test from: :us_core_v400_respiratory_rate_patient_category_status_client_search_test
        test from: :us_core_v400_respiratory_rate_patient_code_date_client_search_test
        test from: :us_core_v400_respiratory_rate_patient_category_date_client_search_test
        test from: :us_core_v400_respiratory_rate_patient_category_client_search_test
      end
    end
  end
end
