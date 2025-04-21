# frozen_string_literal: true

require_relative 'immunization/immunization_client_read_test'
require_relative 'immunization/immunization_patient_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class ImmunizationClientGroup < Inferno::TestGroup
        id :us_core_client_v700_immunization

        title 'Immunization'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Immunization queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-immunization`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient

        )

        run_as_group

        test from: :us_core_v700_immunization_client_read_test
        test from: :us_core_v700_immunization_patient_client_search_test
      end
    end
  end
end
