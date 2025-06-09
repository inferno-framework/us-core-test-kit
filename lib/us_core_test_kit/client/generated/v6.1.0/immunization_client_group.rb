# frozen_string_literal: true

require_relative 'immunization/immunization_client_read_test'
require_relative 'immunization/immunization_patient_client_search_test'
require_relative 'immunization/immunization_patient_date_client_search_test'
require_relative 'immunization/immunization_patient_status_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class ImmunizationClientGroup < Inferno::TestGroup
        id :us_core_client_v610_immunization
        title 'Immunization'
        description %(
          
# Background

This test group verifies that the client can access Immunization data
conforming to the US Core Immunization Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Immunization FHIR resource type. However, if they
do support it, they must support the US Core Immunization Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Immunization resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-immunization`

## Searching
These tests will check that the client performed searches agains the
Immunization resource type with the following required parameters:

* patient

Inferno will also look for searches using the following optional parameters:

* patient + date
* patient + status


        )
        optional true
        run_as_group

        test from: :us_core_v610_immunization_client_read_test
        test from: :us_core_v610_immunization_patient_client_search_test
        test from: :us_core_v610_immunization_patient_date_client_search_test
        test from: :us_core_v610_immunization_patient_status_client_search_test
      end
    end
  end
end
