# frozen_string_literal: true

require_relative 'procedure/procedure_client_read_test'
require_relative 'procedure/procedure_patient_client_search_test'
require_relative 'procedure/procedure_patient_date_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class ProcedureClientGroup < Inferno::TestGroup
        id :us_core_client_v311_procedure

        title 'Procedure'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Procedure queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-procedure`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient
* patient + date

        )

        run_as_group

        test from: :us_core_v311_procedure_client_read_test
        test from: :us_core_v311_procedure_patient_client_search_test
        test from: :us_core_v311_procedure_patient_date_client_search_test
      end
    end
  end
end
