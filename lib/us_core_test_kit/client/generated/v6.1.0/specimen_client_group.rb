# frozen_string_literal: true

require_relative 'specimen/specimen_client_read_test'
require_relative 'specimen/specimen_id_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class SpecimenClientGroup < Inferno::TestGroup
        id :us_core_client_v610_specimen

        title 'Specimen'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Specimen queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-specimen`

## Searching
This sequence will check that the client performed searches with the following parameters:

* _id

        )

        run_as_group

        test from: :us_core_v610_specimen_client_read_test
        test from: :us_core_v610_specimen_id_client_search_test
      end
    end
  end
end
