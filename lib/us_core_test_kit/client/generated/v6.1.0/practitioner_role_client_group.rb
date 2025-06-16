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

This test group verifies that the client can access PractitionerRole data
conforming to the US Core PractitionerRole Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the PractitionerRole FHIR resource type. However, if they
do support it, they must support the US Core PractitionerRole Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
PractitionerRole resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-practitioner-role`

## Searching
These tests will check that the client performed searches agains the
PractitionerRole resource type with the following required parameters:

* specialty
* practitioner

Inferno will also look for searches using the following optional parameters:




        )
        optional true
        run_as_group

        test from: :us_core_v610_practitioner_role_client_read_test
        test from: :us_core_v610_practitioner_role_specialty_client_search_test
        test from: :us_core_v610_practitioner_role_practitioner_client_search_test
      end
    end
  end
end
