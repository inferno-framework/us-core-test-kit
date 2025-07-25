# frozen_string_literal: true

require_relative 'organization/organization_client_read_test'
require_relative 'organization/organization_name_client_search_test'
require_relative 'organization/organization_address_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV400
      class OrganizationClientGroup < Inferno::TestGroup
        id :us_core_client_v400_organization
        title 'Organization'
        description %(
          
# Background

This test group verifies that the client can access Organization data
conforming to the US Core Organization Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Organization FHIR resource type. However, if they
do support it, they must support the US Core Organization Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Organization resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-organization`

## Searching
These tests will check that the client performed searches agains the
Organization resource type with the following required parameters:



Inferno will also look for searches using the following optional parameters:

* name
* address


        )
        optional true
        run_as_group

        test from: :us_core_v400_organization_client_read_test
        test from: :us_core_v400_organization_name_client_search_test
        test from: :us_core_v400_organization_address_client_search_test
      end
    end
  end
end
