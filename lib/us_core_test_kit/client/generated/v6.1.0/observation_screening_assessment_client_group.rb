# frozen_string_literal: true

require_relative 'observation_screening_assessment/observation_screening_assessment_client_support_test'
require_relative 'observation_screening_assessment/observation_screening_assessment_client_read_test'
require_relative 'observation_screening_assessment/observation_screening_assessment_patient_category_client_search_test'
require_relative 'observation_screening_assessment/observation_screening_assessment_patient_code_date_client_search_test'
require_relative 'observation_screening_assessment/observation_screening_assessment_patient_category_status_client_search_test'
require_relative 'observation_screening_assessment/observation_screening_assessment_patient_category_date_client_search_test'
require_relative 'observation_screening_assessment/observation_screening_assessment_patient_code_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class ObservationScreeningAssessmentClientGroup < Inferno::TestGroup
        id :us_core_client_v610_observation_screening_assessment
        title 'Observation Screening Assessment'
        description %(
          
# Background

This test group verifies that the client can access Observation data
conforming to the US Core Observation Screening Assessment Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Observation FHIR resource type. However, if they
do support it, they must support the US Core Observation Screening Assessment Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Observation resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-observation-screening-assessment`

## Searching
These tests will check that the client performed searches agains the
Observation resource type with the following required parameters:

* patient + category
* patient + category + date
* patient + code

Inferno will also look for searches using the following optional parameters:

* patient + code + date
* patient + category + status


        )
        optional true
        run_as_group

        test from: :us_core_v610_observation_screening_assessment_client_support_test
        test from: :us_core_v610_observation_screening_assessment_client_read_test
        test from: :us_core_v610_observation_screening_assessment_patient_category_client_search_test
        test from: :us_core_v610_observation_screening_assessment_patient_code_date_client_search_test
        test from: :us_core_v610_observation_screening_assessment_patient_category_status_client_search_test
        test from: :us_core_v610_observation_screening_assessment_patient_category_date_client_search_test
        test from: :us_core_v610_observation_screening_assessment_patient_code_client_search_test
      end
    end
  end
end
