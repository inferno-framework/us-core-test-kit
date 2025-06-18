# frozen_string_literal: true

require_relative 'encounter/encounter_client_read_test'
require_relative 'encounter/encounter_patient_client_search_test'
require_relative 'encounter/encounter_id_client_search_test'
require_relative 'encounter/encounter_identifier_client_search_test'
require_relative 'encounter/encounter_patient_status_client_search_test'
require_relative 'encounter/encounter_patient_lastupdated_client_search_test'
require_relative 'encounter/encounter_date_patient_client_search_test'
require_relative 'encounter/encounter_patient_type_client_search_test'
require_relative 'encounter/encounter_patient_location_client_search_test'
require_relative 'encounter/encounter_patient_discharge_disposition_client_search_test'
require_relative 'encounter/encounter_class_patient_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV800
      class EncounterClientGroup < Inferno::TestGroup
        id :us_core_client_v800_encounter
        title 'Encounter'
        description %(
          
# Background

This test group verifies that the client can access Encounter data
conforming to the US Core Encounter Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Encounter FHIR resource type. However, if they
do support it, they must support the US Core Encounter Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Encounter resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-encounter`

## Searching
These tests will check that the client performed searches agains the
Encounter resource type with the following required parameters:

* patient
* _id
* date + patient

Inferno will also look for searches using the following optional parameters:

* identifier
* patient + status
* patient + _lastUpdated
* patient + type
* patient + location
* patient + discharge-disposition
* class + patient


        )
        optional true
        run_as_group

        test from: :us_core_v800_encounter_client_read_test
        test from: :us_core_v800_encounter_patient_client_search_test
        test from: :us_core_v800_encounter_id_client_search_test
        test from: :us_core_v800_encounter_identifier_client_search_test
        test from: :us_core_v800_encounter_patient_status_client_search_test
        test from: :us_core_v800_encounter_patient_lastupdated_client_search_test
        test from: :us_core_v800_encounter_date_patient_client_search_test
        test from: :us_core_v800_encounter_patient_type_client_search_test
        test from: :us_core_v800_encounter_patient_location_client_search_test
        test from: :us_core_v800_encounter_patient_discharge_disposition_client_search_test
        test from: :us_core_v800_encounter_class_patient_client_search_test
      end
    end
  end
end
