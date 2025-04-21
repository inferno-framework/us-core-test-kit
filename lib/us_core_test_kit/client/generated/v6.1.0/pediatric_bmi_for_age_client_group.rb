# frozen_string_literal: true

require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_client_read_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_patient_code_client_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_patient_category_date_client_search_test'
require_relative 'pediatric_bmi_for_age/pediatric_bmi_for_age_patient_category_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class PediatricBmiForAgeClientGroup < Inferno::TestGroup
        id :us_core_client_v610_pediatric_bmi_for_age

        title 'Observation Pediatric BMI for Age'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Observation queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-pediatric-bmi-for-age`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + code
* patient + category + date
* patient + category

        )

        run_as_group

        test from: :us_core_v610_pediatric_bmi_for_age_client_read_test
        test from: :us_core_v610_pediatric_bmi_for_age_patient_code_client_search_test
        test from: :us_core_v610_pediatric_bmi_for_age_patient_category_date_client_search_test
        test from: :us_core_v610_pediatric_bmi_for_age_patient_category_client_search_test
      end
    end
  end
end
