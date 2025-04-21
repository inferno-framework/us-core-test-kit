# frozen_string_literal: true

require_relative 'medication_request/medication_request_client_read_test'
require_relative 'medication_request/medication_request_patient_intent_client_search_test'
require_relative 'medication_request/medication_request_patient_intent_status_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class MedicationRequestClientGroup < Inferno::TestGroup
        id :us_core_client_v610_medication_request

        title 'MedicationRequest'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required MedicationRequest queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-medication-request`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + intent
* patient + intent + status

        )

        run_as_group

        test from: :us_core_v610_medication_request_client_read_test
        test from: :us_core_v610_medication_request_patient_intent_client_search_test
        test from: :us_core_v610_medication_request_patient_intent_status_client_search_test
      end
    end
  end
end
