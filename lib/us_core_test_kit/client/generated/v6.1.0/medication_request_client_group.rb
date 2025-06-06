# frozen_string_literal: true

require_relative 'medication_request/medication_request_client_support_test'
require_relative 'medication_request/medication_request_client_read_test'
require_relative 'medication_request/medication_request_patient_intent_client_search_test'
require_relative 'medication_request/medication_request_patient_intent_encounter_client_search_test'
require_relative 'medication_request/medication_request_patient_intent_status_client_search_test'
require_relative 'medication_request/medication_request_patient_intent_authoredon_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class MedicationRequestClientGroup < Inferno::TestGroup
        id :us_core_client_v610_medication_request
        title 'MedicationRequest'
        description %(
          
# Background

This test group verifies that the client can access MedicationRequest data
conforming to the US Core MedicationRequest Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the MedicationRequest FHIR resource type. However, if they
do support it, they must support the US Core MedicationRequest Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
MedicationRequest resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-medication-request`

## Searching
These tests will check that the client performed searches agains the
MedicationRequest resource type with the following required parameters:

* patient + intent
* patient + intent + status

Inferno will also look for searches using the following optional parameters:

* patient + intent + encounter
* patient + intent + authoredon


        )
        optional true
        run_as_group

        test from: :us_core_v610_medication_request_client_support_test
        test from: :us_core_v610_medication_request_client_read_test
        test from: :us_core_v610_medication_request_patient_intent_client_search_test
        test from: :us_core_v610_medication_request_patient_intent_encounter_client_search_test
        test from: :us_core_v610_medication_request_patient_intent_status_client_search_test
        test from: :us_core_v610_medication_request_patient_intent_authoredon_client_search_test
      end
    end
  end
end
