# frozen_string_literal: true

require_relative 'pediatric_weight_for_height/pediatric_weight_for_height_client_read_test'
require_relative 'pediatric_weight_for_height/pediatric_weight_for_height_patient_code_client_search_test'
require_relative 'pediatric_weight_for_height/pediatric_weight_for_height_patient_category_date_client_search_test'
require_relative 'pediatric_weight_for_height/pediatric_weight_for_height_patient_category_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class PediatricWeightForHeightClientGroup < Inferno::TestGroup
        id :us_core_client_v311_pediatric_weight_for_height

        title 'Pediatric Weight for Height Observation'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Observation queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-pediatric-weight-for-height`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + code
* patient + category + date
* patient + category

        )

        run_as_group

        test from: :us_core_v311_pediatric_weight_for_height_client_read_test
        test from: :us_core_v311_pediatric_weight_for_height_patient_code_client_search_test
        test from: :us_core_v311_pediatric_weight_for_height_patient_category_date_client_search_test
        test from: :us_core_v311_pediatric_weight_for_height_patient_category_client_search_test
      end
    end
  end
end
