# frozen_string_literal: true

require_relative 'practitioner_role/practitioner_role_client_read_test'
require_relative 'practitioner_role/practitioner_role_specialty_client_search_test'
require_relative 'practitioner_role/practitioner_role_practitioner_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV610
      class PractitionerRoleClientGroup < Inferno::TestGroup
        id :us_core_client_v610_practitioner_role

        title 'PractitionerRole'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required PractitionerRole queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-practitioner-role`

## Searching
This sequence will check that the client performed searches with the following parameters:

* specialty
* practitioner

        )

        run_as_group

        test from: :us_core_v610_practitioner_role_client_read_test
        test from: :us_core_v610_practitioner_role_specialty_client_search_test
        test from: :us_core_v610_practitioner_role_practitioner_client_search_test
      end
    end
  end
end
