# frozen_string_literal: true

require_relative 'provenance/provenance_client_read_test'

module USCoreTestKit
  module Client
    module USCoreClientV311
      class ProvenanceClientGroup < Inferno::TestGroup
        id :us_core_client_v311_provenance
        title 'Provenance'
        description %(
          
# Background

This test group verifies that the client can access Provenance data
conforming to the US Core Provenance Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Provenance FHIR resource type. However, if they
do support it, they must support the US Core Provenance Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Provenance resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-provenance`

## Searching
These tests will check that the client performed searches agains the
Provenance resource type with the following required parameters:



Inferno will also look for searches using the following optional parameters:




        )
        optional true
        run_as_group

        test from: :us_core_v311_provenance_client_read_test
      end
    end
  end
end
