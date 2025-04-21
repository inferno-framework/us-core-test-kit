# frozen_string_literal: true

require_relative 'care_plan/care_plan_client_read_test'
require_relative 'care_plan/care_plan_patient_category_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class CarePlanClientGroup < Inferno::TestGroup
        id :us_core_client_v610_care_plan

        title 'CarePlan'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required CarePlan queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-care-plan`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient + category

        )

        run_as_group

        test from: :us_core_v610_care_plan_client_read_test
        test from: :us_core_v610_care_plan_patient_category_client_search_test
      end
    end
  end
end
