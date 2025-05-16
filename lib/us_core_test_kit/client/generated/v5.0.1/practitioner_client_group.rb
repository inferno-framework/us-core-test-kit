# frozen_string_literal: true

require_relative 'practitioner/practitioner_client_read_test'
require_relative 'practitioner/practitioner_name_client_search_test'
require_relative 'practitioner/practitioner_identifier_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV501
      class PractitionerClientGroup < Inferno::TestGroup
        id :us_core_client_v501_practitioner

        title 'Practitioner'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Practitioner queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-practitioner`

## Searching
This sequence will check that the client performed searches with the following parameters:

* name
* identifier

        )

        run_as_group

        test from: :us_core_v501_practitioner_client_read_test
        test from: :us_core_v501_practitioner_name_client_search_test
        test from: :us_core_v501_practitioner_identifier_client_search_test
      end
    end
  end
end
