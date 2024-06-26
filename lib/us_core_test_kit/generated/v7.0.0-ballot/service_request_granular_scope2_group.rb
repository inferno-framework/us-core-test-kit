require_relative './granular_scope_tests/service_request/service_request_patient_granular_scope_search_test'
require_relative './granular_scope_tests/service_request/service_request_id_granular_scope_search_test'
require_relative './granular_scope_tests/service_request/service_request_patient_category_authored_granular_scope_search_test'
require_relative './granular_scope_tests/service_request/service_request_patient_category_granular_scope_search_test'
require_relative './granular_scope_tests/service_request/service_request_patient_code_authored_granular_scope_search_test'
require_relative './granular_scope_tests/service_request/service_request_patient_code_granular_scope_search_test'
require_relative './granular_scope_tests/service_request/service_request_patient_status_granular_scope_search_test'
require_relative './granular_scope_tests/service_request/service_request_granular_scope_read_test'

module USCoreTestKit
  module USCoreV700_BALLOT
    class ServiceRequestGranularScope2Group < Inferno::TestGroup
      title 'ServiceRequest Granular Scope Tests Tests'
      short_description 'Verify support for the server capabilities required by the US Core ServiceRequest Profile.'
      description %(
  The tests in this group repeat all of the searches from the US Core
FHIR API tests, and verify that the resources returned are filtered
based on the following granular scopes:

* `ServiceRequest.rs?category=http://hl7.org/fhir/us/core/CodeSystem/us-core-category|functional-status`
* `ServiceRequest.rs?category=http://snomed.info/sct|387713003`

      )

      id :us_core_v700_ballot_service_request_granular_scope_2_group
      run_as_group

    
      test from: :us_core_v700_ballot_ServiceRequest_patient_granular_scope_search_test
      test from: :us_core_v700_ballot_ServiceRequest__id_granular_scope_search_test
      test from: :us_core_v700_ballot_ServiceRequest_patient_category_authored_granular_scope_search_test
      test from: :us_core_v700_ballot_ServiceRequest_patient_category_granular_scope_search_test
      test from: :us_core_v700_ballot_ServiceRequest_patient_code_authored_granular_scope_search_test
      test from: :us_core_v700_ballot_ServiceRequest_patient_code_granular_scope_search_test
      test from: :us_core_v700_ballot_ServiceRequest_patient_status_granular_scope_search_test
      test from: :us_core_v700_ballot_ServiceRequest_granular_scope_read_test
    end
  end
end
