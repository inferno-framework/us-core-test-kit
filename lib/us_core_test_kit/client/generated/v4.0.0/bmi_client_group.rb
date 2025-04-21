# frozen_string_literal: true

require_relative 'bmi/bmi_client_read_test'
require_relative 'bmi/bmi_patient_code_client_search_test'
require_relative 'bmi/bmi_patient_category_client_search_test'
require_relative 'bmi/bmi_patient_category_date_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class BmiClientGroup < Inferno::TestGroup
        id :us_core_client_v400_bmi

        title 'Observation BMI'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Observation queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-bmi`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + code
* patient + category
* patient + category + date

        )

        run_as_group

        test from: :us_core_v400_bmi_client_read_test
        test from: :us_core_v400_bmi_patient_code_client_search_test
        test from: :us_core_v400_bmi_patient_category_client_search_test
        test from: :us_core_v400_bmi_patient_category_date_client_search_test
      end
    end
  end
end
