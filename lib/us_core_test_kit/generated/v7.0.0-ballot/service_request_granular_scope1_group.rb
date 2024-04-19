require_relative './granular_scope_tests/service_request/service_request_patient_granular_scope_test'
require_relative './granular_scope_tests/service_request/service_request_id_granular_scope_test'
require_relative './granular_scope_tests/service_request/service_request_patient_category_authored_granular_scope_test'
require_relative './granular_scope_tests/service_request/service_request_patient_category_granular_scope_test'
require_relative './granular_scope_tests/service_request/service_request_patient_code_authored_granular_scope_test'
require_relative './granular_scope_tests/service_request/service_request_patient_code_granular_scope_test'
require_relative './granular_scope_tests/service_request/service_request_patient_status_granular_scope_test'
require_relative './granular_scope_tests/service_request/service_request_read_granular_scope_test'

module USCoreTestKit
  module USCoreV700_BALLOT
    class ServiceRequestGranularScope1Group < Inferno::TestGroup
      title 'ServiceRequest Granular Scope Tests Tests'
      short_description 'Verify support for the server capabilities required by the US Core ServiceRequest Profile.'
      description %(
  The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `ServiceRequest.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|sdoh`

      )

      id :us_core_v700_ballot_service_request_granular_scope_1_group
      run_as_group

    
      test from: :us_core_v700_ballot_ServiceRequest_patient_granular_scope_test
      test from: :us_core_v700_ballot_ServiceRequest__id_granular_scope_test
      test from: :us_core_v700_ballot_ServiceRequest_patient_category_authored_granular_scope_test
      test from: :us_core_v700_ballot_ServiceRequest_patient_category_granular_scope_test
      test from: :us_core_v700_ballot_ServiceRequest_patient_code_authored_granular_scope_test
      test from: :us_core_v700_ballot_ServiceRequest_patient_code_granular_scope_test
      test from: :us_core_v700_ballot_ServiceRequest_patient_status_granular_scope_test
      test from: :us_core_v700_ballot_ServiceRequest_read_granular_scope_test
    end
  end
end
