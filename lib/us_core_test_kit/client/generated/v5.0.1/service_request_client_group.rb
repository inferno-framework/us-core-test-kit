# frozen_string_literal: true

require_relative 'service_request/service_request_client_read_test'
require_relative 'service_request/service_request_patient_client_search_test'
require_relative 'service_request/service_request_id_client_search_test'
require_relative 'service_request/service_request_patient_category_authored_client_search_test'
require_relative 'service_request/service_request_patient_code_client_search_test'
require_relative 'service_request/service_request_patient_category_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV501
      class ServiceRequestClientGroup < Inferno::TestGroup
        id :us_core_client_v501_service_request

        title 'ServiceRequest'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required ServiceRequest queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-service-request`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient
* _id
* patient + category + authored
* patient + code
* patient + category

        )

        run_as_group

        test from: :us_core_v501_service_request_client_read_test
        test from: :us_core_v501_service_request_patient_client_search_test
        test from: :us_core_v501_service_request_id_client_search_test
        test from: :us_core_v501_service_request_patient_category_authored_client_search_test
        test from: :us_core_v501_service_request_patient_code_client_search_test
        test from: :us_core_v501_service_request_patient_category_client_search_test
      end
    end
  end
end
