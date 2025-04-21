# frozen_string_literal: true

require_relative 'average_blood_pressure/average_blood_pressure_client_read_test'
require_relative 'average_blood_pressure/average_blood_pressure_patient_code_client_search_test'
require_relative 'average_blood_pressure/average_blood_pressure_patient_category_date_client_search_test'
require_relative 'average_blood_pressure/average_blood_pressure_patient_category_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class AverageBloodPressureClientGroup < Inferno::TestGroup
        id :us_core_client_v700_average_blood_pressure

        title 'Observation Average Blood Pressure'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Observation queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-average-blood-pressure`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + code
* patient + category + date
* patient + category

        )

        run_as_group

        test from: :us_core_v700_average_blood_pressure_client_read_test
        test from: :us_core_v700_average_blood_pressure_patient_code_client_search_test
        test from: :us_core_v700_average_blood_pressure_patient_category_date_client_search_test
        test from: :us_core_v700_average_blood_pressure_patient_category_client_search_test
      end
    end
  end
end
