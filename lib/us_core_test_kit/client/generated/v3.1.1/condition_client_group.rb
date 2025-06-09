# frozen_string_literal: true

require_relative 'condition/condition_client_read_test'
require_relative 'condition/condition_patient_client_search_test'
require_relative 'condition/condition_category_client_search_test'
require_relative 'condition/condition_clinical_status_client_search_test'
require_relative 'condition/condition_onset_date_client_search_test'
require_relative 'condition/condition_code_client_search_test'
require_relative 'condition/condition_patient_onset_date_client_search_test'
require_relative 'condition/condition_patient_category_client_search_test'
require_relative 'condition/condition_patient_clinical_status_client_search_test'
require_relative 'condition/condition_patient_code_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class ConditionClientGroup < Inferno::TestGroup
        id :us_core_client_v311_condition
        title 'Condition'
        description %(
          
# Background

This test group verifies that the client can access Condition data
conforming to the US Core Condition Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Condition FHIR resource type. However, if they
do support it, they must support the US Core Condition Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Condition resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-condition`

## Searching
These tests will check that the client performed searches agains the
Condition resource type with the following required parameters:



Inferno will also look for searches using the following optional parameters:

* patient
* category
* clinical-status
* onset-date
* code
* patient + onset-date
* patient + category
* patient + clinical-status
* patient + code


        )
        optional true
        run_as_group

        test from: :us_core_v311_condition_client_read_test
        test from: :us_core_v311_condition_patient_client_search_test
        test from: :us_core_v311_condition_category_client_search_test
        test from: :us_core_v311_condition_clinical_status_client_search_test
        test from: :us_core_v311_condition_onset_date_client_search_test
        test from: :us_core_v311_condition_code_client_search_test
        test from: :us_core_v311_condition_patient_onset_date_client_search_test
        test from: :us_core_v311_condition_patient_category_client_search_test
        test from: :us_core_v311_condition_patient_clinical_status_client_search_test
        test from: :us_core_v311_condition_patient_code_client_search_test
      end
    end
  end
end
