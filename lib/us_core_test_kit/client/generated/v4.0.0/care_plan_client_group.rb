# frozen_string_literal: true

require_relative 'care_plan/care_plan_client_read_test'
require_relative 'care_plan/care_plan_client_support_test'
require_relative 'care_plan/care_plan_patient_category_client_search_test'
require_relative 'care_plan/care_plan_category_client_search_test'
require_relative 'care_plan/care_plan_date_client_search_test'
require_relative 'care_plan/care_plan_patient_client_search_test'
require_relative 'care_plan/care_plan_status_client_search_test'
require_relative 'care_plan/care_plan_patient_category_date_client_search_test'
require_relative 'care_plan/care_plan_patient_category_status_date_client_search_test'
require_relative 'care_plan/care_plan_patient_category_status_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class CarePlanClientGroup < Inferno::TestGroup
        id :us_core_client_v400_care_plan
        title 'CarePlan'
        description %(
          
# Background

This test group verifies that the client can access CarePlan data
conforming to the US Core CarePlan Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the CarePlan FHIR resource type. However, if they
do support it, they must support the US Core CarePlan Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
CarePlan resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-care-plan`

## Searching
These tests will check that the client performed searches agains the
CarePlan resource type with the following required parameters:



Inferno will also look for searches using the following optional parameters:

* patient + category
* category
* date
* patient
* status
* patient + category + date
* patient + category + status + date
* patient + category + status


        )
        optional true
        run_as_group

        test from: :us_core_v400_care_plan_client_support_test
        test from: :us_core_v400_care_plan_client_read_test
        test from: :us_core_v400_care_plan_patient_category_client_search_test
        test from: :us_core_v400_care_plan_category_client_search_test
        test from: :us_core_v400_care_plan_date_client_search_test
        test from: :us_core_v400_care_plan_patient_client_search_test
        test from: :us_core_v400_care_plan_status_client_search_test
        test from: :us_core_v400_care_plan_patient_category_date_client_search_test
        test from: :us_core_v400_care_plan_patient_category_status_date_client_search_test
        test from: :us_core_v400_care_plan_patient_category_status_client_search_test
      end
    end
  end
end
