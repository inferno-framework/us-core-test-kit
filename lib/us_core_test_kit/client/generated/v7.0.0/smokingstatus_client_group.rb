# frozen_string_literal: true

require_relative 'smokingstatus/smokingstatus_client_support_test'
require_relative 'smokingstatus/smokingstatus_client_read_test'
require_relative 'smokingstatus/smokingstatus_patient_code_client_search_test'
require_relative 'smokingstatus/smokingstatus_patient_category_date_client_search_test'
require_relative 'smokingstatus/smokingstatus_patient_code_date_client_search_test'
require_relative 'smokingstatus/smokingstatus_patient_category_status_client_search_test'
require_relative 'smokingstatus/smokingstatus_patient_category_lastupdated_client_search_test'
require_relative 'smokingstatus/smokingstatus_patient_category_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class SmokingstatusClientGroup < Inferno::TestGroup
        id :us_core_client_v700_smokingstatus
        title 'Observation Smoking Status'
        description %(
          
# Background

This test group verifies that the client can access Observation data
conforming to the US Core Smoking Status Observation Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Observation FHIR resource type. However, if they
do support it, they must support the US Core Smoking Status Observation Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Observation resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-smokingstatus`

## Searching
These tests will check that the client performed searches agains the
Observation resource type with the following required parameters:

* patient + code
* patient + category + date
* patient + category

Inferno will also look for searches using the following optional parameters:

* patient + code + date
* patient + category + status
* patient + category + _lastUpdated


        )
        optional true
        run_as_group

        test from: :us_core_v700_smokingstatus_client_support_test
        test from: :us_core_v700_smokingstatus_client_read_test
        test from: :us_core_v700_smokingstatus_patient_code_client_search_test
        test from: :us_core_v700_smokingstatus_patient_category_date_client_search_test
        test from: :us_core_v700_smokingstatus_patient_code_date_client_search_test
        test from: :us_core_v700_smokingstatus_patient_category_status_client_search_test
        test from: :us_core_v700_smokingstatus_patient_category_lastupdated_client_search_test
        test from: :us_core_v700_smokingstatus_patient_category_client_search_test
      end
    end
  end
end
