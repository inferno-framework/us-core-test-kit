# frozen_string_literal: true

require_relative 'patient/patient_client_read_test'
require_relative 'patient/patient_id_client_search_test'
require_relative 'patient/patient_identifier_client_search_test'
require_relative 'patient/patient_name_client_search_test'
require_relative 'patient/patient_birthdate_name_client_search_test'
require_relative 'patient/patient_family_gender_client_search_test'
require_relative 'patient/patient_birthdate_family_client_search_test'
require_relative 'patient/patient_gender_name_client_search_test'
require_relative 'patient/patient_death_date_family_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class PatientClientGroup < Inferno::TestGroup
        id :us_core_client_v700_patient
        title 'Patient'
        description %(
          
# Background

This test group verifies that the client can access Patient data
conforming to the US Core Patient Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Patient FHIR resource type. However, if they
do support it, they must support the US Core Patient Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Patient resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-patient`

## Searching
These tests will check that the client performed searches agains the
Patient resource type with the following required parameters:

* _id
* identifier
* name
* birthdate + name
* gender + name

Inferno will also look for searches using the following optional parameters:

* family + gender
* birthdate + family
* death-date + family


        )
        optional true
        run_as_group

        test from: :us_core_v700_patient_client_read_test
        test from: :us_core_v700_patient_id_client_search_test
        test from: :us_core_v700_patient_identifier_client_search_test
        test from: :us_core_v700_patient_name_client_search_test
        test from: :us_core_v700_patient_birthdate_name_client_search_test
        test from: :us_core_v700_patient_family_gender_client_search_test
        test from: :us_core_v700_patient_birthdate_family_client_search_test
        test from: :us_core_v700_patient_gender_name_client_search_test
        test from: :us_core_v700_patient_death_date_family_client_search_test
      end
    end
  end
end
