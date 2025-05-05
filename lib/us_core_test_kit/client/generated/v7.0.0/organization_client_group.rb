# frozen_string_literal: true

require_relative 'organization/organization_client_read_test'
require_relative 'organization/organization_address_client_search_test'
require_relative 'organization/organization_name_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class OrganizationClientGroup < Inferno::TestGroup
        id :us_core_client_v700_organization

        title 'Organization'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Organization queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-organization`

## Searching
This sequence will check that the client performed searches with the following parameters:

* address
* name

        )

        run_as_group

        test from: :us_core_v700_organization_client_read_test
        test from: :us_core_v700_organization_address_client_search_test
        test from: :us_core_v700_organization_name_client_search_test
      end
    end
  end
end
