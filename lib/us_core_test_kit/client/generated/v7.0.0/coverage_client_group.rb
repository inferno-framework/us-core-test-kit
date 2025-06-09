# frozen_string_literal: true

require_relative 'coverage/coverage_client_read_test'
require_relative 'coverage/coverage_patient_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class CoverageClientGroup < Inferno::TestGroup
        id :us_core_client_v700_coverage
        title 'Coverage'
        description %(
          
# Background

This test group verifies that the client can access Coverage data
conforming to the US Core Coverage Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Coverage FHIR resource type. However, if they
do support it, they must support the US Core Coverage Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Coverage resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-coverage`

## Searching
These tests will check that the client performed searches agains the
Coverage resource type with the following required parameters:

* patient

Inferno will also look for searches using the following optional parameters:




        )
        optional true
        run_as_group

        test from: :us_core_v700_coverage_client_read_test
        test from: :us_core_v700_coverage_patient_client_search_test
      end
    end
  end
end
