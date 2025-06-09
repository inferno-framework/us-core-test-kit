# frozen_string_literal: true

require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_client_read_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_category_client_search_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_client_search_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_category_clinical_status_client_search_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_onset_date_client_search_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_abatement_date_client_search_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_clinical_status_client_search_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_asserted_date_client_search_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_code_client_search_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_category_encounter_client_search_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_lastupdated_client_search_test'
require_relative 'condition_encounter_diagnosis/condition_encounter_diagnosis_patient_recorded_date_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class ConditionEncounterDiagnosisClientGroup < Inferno::TestGroup
        id :us_core_client_v700_condition_encounter_diagnosis
        title 'Condition Encounter Diagnosis'
        description %(
          
# Background

This test group verifies that the client can access Condition data
conforming to the US Core Condition Encounter Diagnosis Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Condition FHIR resource type. However, if they
do support it, they must support the US Core Condition Encounter Diagnosis Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Condition resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-condition-encounter-diagnosis`

## Searching
These tests will check that the client performed searches agains the
Condition resource type with the following required parameters:

* patient + category
* patient

Inferno will also look for searches using the following optional parameters:

* patient + category + clinical-status
* patient + onset-date
* patient + abatement-date
* patient + clinical-status
* patient + asserted-date
* patient + code
* patient + category + encounter
* patient + _lastUpdated
* patient + recorded-date


        )
        optional true
        run_as_group

        test from: :us_core_v700_condition_encounter_diagnosis_client_read_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_category_client_search_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_client_search_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_category_clinical_status_client_search_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_onset_date_client_search_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_abatement_date_client_search_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_clinical_status_client_search_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_asserted_date_client_search_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_code_client_search_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_category_encounter_client_search_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_lastupdated_client_search_test
        test from: :us_core_v700_condition_encounter_diagnosis_patient_recorded_date_client_search_test
      end
    end
  end
end
