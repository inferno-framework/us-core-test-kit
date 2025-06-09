# frozen_string_literal: true

require_relative 'service_request/service_request_client_read_test'
require_relative 'service_request/service_request_patient_client_search_test'
require_relative 'service_request/service_request_id_client_search_test'
require_relative 'service_request/service_request_patient_code_client_search_test'
require_relative 'service_request/service_request_patient_category_authored_client_search_test'
require_relative 'service_request/service_request_patient_code_authored_client_search_test'
require_relative 'service_request/service_request_patient_status_client_search_test'
require_relative 'service_request/service_request_patient_category_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class ServiceRequestClientGroup < Inferno::TestGroup
        id :us_core_client_v700_service_request
        title 'ServiceRequest'
        description %(
          
# Background

This test group verifies that the client can access ServiceRequest data
conforming to the US Core ServiceRequest Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the ServiceRequest FHIR resource type. However, if they
do support it, they must support the US Core ServiceRequest Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
ServiceRequest resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-service-request`

## Searching
These tests will check that the client performed searches agains the
ServiceRequest resource type with the following required parameters:

* patient
* _id
* patient + code
* patient + category + authored
* patient + category

Inferno will also look for searches using the following optional parameters:

* patient + code + authored
* patient + status


        )
        optional true
        run_as_group

        test from: :us_core_v700_service_request_client_read_test
        test from: :us_core_v700_service_request_patient_client_search_test
        test from: :us_core_v700_service_request_id_client_search_test
        test from: :us_core_v700_service_request_patient_code_client_search_test
        test from: :us_core_v700_service_request_patient_category_authored_client_search_test
        test from: :us_core_v700_service_request_patient_code_authored_client_search_test
        test from: :us_core_v700_service_request_patient_status_client_search_test
        test from: :us_core_v700_service_request_patient_category_client_search_test
      end
    end
  end
end
