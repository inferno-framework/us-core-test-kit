# frozen_string_literal: true

require_relative 'coverage/coverage_client_read_test'
require_relative 'coverage/coverage_patient_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class CoverageClientGroup < Inferno::TestGroup
        id :us_core_client_v610_coverage

        title 'Coverage'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Coverage queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-coverage`

## Searching
This sequence will check that the client performed searches with the following parameters:

* patient

        )

        run_as_group

        test from: :us_core_v610_coverage_client_read_test
        test from: :us_core_v610_coverage_patient_client_search_test
      end
    end
  end
end
