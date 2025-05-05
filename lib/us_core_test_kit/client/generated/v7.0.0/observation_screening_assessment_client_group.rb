# frozen_string_literal: true

require_relative 'observation_screening_assessment/observation_screening_assessment_client_read_test'
require_relative 'observation_screening_assessment/observation_screening_assessment_patient_category_client_search_test'
require_relative 'observation_screening_assessment/observation_screening_assessment_patient_code_client_search_test'
require_relative 'observation_screening_assessment/observation_screening_assessment_patient_category_date_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class ObservationScreeningAssessmentClientGroup < Inferno::TestGroup
        id :us_core_client_v700_observation_screening_assessment

        title 'Observation Screening Assessment'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Observation queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-observation-screening-assessment`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + category
* patient + code
* patient + category + date

        )

        run_as_group

        test from: :us_core_v700_observation_screening_assessment_client_read_test
        test from: :us_core_v700_observation_screening_assessment_patient_category_client_search_test
        test from: :us_core_v700_observation_screening_assessment_patient_code_client_search_test
        test from: :us_core_v700_observation_screening_assessment_patient_category_date_client_search_test
      end
    end
  end
end
