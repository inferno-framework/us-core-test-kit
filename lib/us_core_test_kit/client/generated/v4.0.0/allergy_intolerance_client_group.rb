# frozen_string_literal: true

require_relative 'allergy_intolerance/allergy_intolerance_client_read_test'
require_relative 'allergy_intolerance/allergy_intolerance_patient_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class AllergyIntoleranceClientGroup < Inferno::TestGroup
        id :us_core_client_v400_allergy_intolerance

        title 'AllergyIntolerance'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required AllergyIntolerance queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-allergy-intolerance`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient

        )

        run_as_group

        test from: :us_core_v400_allergy_intolerance_client_read_test
        test from: :us_core_v400_allergy_intolerance_patient_client_search_test
      end
    end
  end
end
