# frozen_string_literal: true

require_relative 'procedure/procedure_client_read_test'
require_relative 'procedure/procedure_patient_client_search_test'
require_relative 'procedure/procedure_patient_code_date_client_search_test'
require_relative 'procedure/procedure_patient_status_client_search_test'
require_relative 'procedure/procedure_patient_date_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class ProcedureClientGroup < Inferno::TestGroup
        id :us_core_client_v610_procedure
        title 'Procedure'
        description %(
          
# Background

This test group verifies that the client can access Procedure data
conforming to the US Core Procedure Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Procedure FHIR resource type. However, if they
do support it, they must support the US Core Procedure Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Procedure resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-procedure`

## Searching
These tests will check that the client performed searches agains the
Procedure resource type with the following required parameters:

* patient
* patient + date

Inferno will also look for searches using the following optional parameters:

* patient + code + date
* patient + status


        )
        optional true
        run_as_group

        test from: :us_core_v610_procedure_client_read_test
        test from: :us_core_v610_procedure_patient_client_search_test
        test from: :us_core_v610_procedure_patient_code_date_client_search_test
        test from: :us_core_v610_procedure_patient_status_client_search_test
        test from: :us_core_v610_procedure_patient_date_client_search_test
      end
    end
  end
end
