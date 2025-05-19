# frozen_string_literal: true

require_relative 'simple_observation/simple_observation_client_read_test'
require_relative 'simple_observation/simple_observation_patient_category_client_search_test'
require_relative 'simple_observation/simple_observation_patient_category_date_client_search_test'
require_relative 'simple_observation/simple_observation_patient_code_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class SimpleObservationClientGroup < Inferno::TestGroup
        id :us_core_client_v610_simple_observation

        title 'Observation Simple'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Observation queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-simple-observation`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + category
* patient + category + date
* patient + code

        )

        run_as_group

        test from: :us_core_v610_simple_observation_client_read_test
        test from: :us_core_v610_simple_observation_patient_category_client_search_test
        test from: :us_core_v610_simple_observation_patient_category_date_client_search_test
        test from: :us_core_v610_simple_observation_patient_code_client_search_test
      end
    end
  end
end
