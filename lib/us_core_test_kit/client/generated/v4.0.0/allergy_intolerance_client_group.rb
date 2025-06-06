# frozen_string_literal: true

require_relative 'allergy_intolerance/allergy_intolerance_client_read_test'
require_relative 'allergy_intolerance/allergy_intolerance_client_support_test'
require_relative 'allergy_intolerance/allergy_intolerance_patient_client_search_test'
require_relative 'allergy_intolerance/allergy_intolerance_clinical_status_client_search_test'
require_relative 'allergy_intolerance/allergy_intolerance_patient_clinical_status_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class AllergyIntoleranceClientGroup < Inferno::TestGroup
        id :us_core_client_v400_allergy_intolerance
        title 'AllergyIntolerance'
        description %(
          
# Background

This test group verifies that the client can access AllergyIntolerance data
conforming to the US Core AllergyIntolerance Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the AllergyIntolerance FHIR resource type. However, if they
do support it, they must support the US Core AllergyIntolerance Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
AllergyIntolerance resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-allergy-intolerance`

## Searching
These tests will check that the client performed searches agains the
AllergyIntolerance resource type with the following required parameters:



Inferno will also look for searches using the following optional parameters:

* patient
* clinical-status
* patient + clinical-status


        )
        optional true
        run_as_group

        test from: :us_core_v400_allergy_intolerance_client_support_test
        test from: :us_core_v400_allergy_intolerance_client_read_test
        test from: :us_core_v400_allergy_intolerance_patient_client_search_test
        test from: :us_core_v400_allergy_intolerance_clinical_status_client_search_test
        test from: :us_core_v400_allergy_intolerance_patient_clinical_status_client_search_test
      end
    end
  end
end
