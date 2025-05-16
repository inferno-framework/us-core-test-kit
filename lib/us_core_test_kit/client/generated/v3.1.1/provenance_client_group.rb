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

This test group verifies that the client under test is
able to perform the required Provenance queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-provenance`

## Searching
This sequence will check that the client performed searches with the following parameters:



        )

        run_as_group

        test from: :us_core_v311_provenance_client_read_test
      end
    end
  end
end
