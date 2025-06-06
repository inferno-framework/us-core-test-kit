# frozen_string_literal: true

require_relative 'location/location_client_read_test'
require_relative 'location/location_client_support_test'
require_relative 'location/location_address_client_search_test'
require_relative 'location/location_address_city_client_search_test'
require_relative 'location/location_address_postalcode_client_search_test'
require_relative 'location/location_address_state_client_search_test'
require_relative 'location/location_name_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class LocationClientGroup < Inferno::TestGroup
        id :us_core_client_v700_location
        title 'Location'
        description %(
          
# Background

This test group verifies that the client can access Location data
conforming to the US Core Location Profile.

# Testing Methodology

## Data Access Supported

Clients may not be required to support the Location FHIR resource type. However, if they
do support it, they must support the US Core Location Profile and the resource type's search parameters.
The tests in this group will not execute if client makes no attempt to access data for the
Location resource type. In this case, the test will be marked as skip if support
for the resource type is required, and omitted otherwise.

## Reading
This test will check that the client performed a read of the following id:

* `us-core-client-tests-location`

## Searching
These tests will check that the client performed searches agains the
Location resource type with the following required parameters:

* address
* name

Inferno will also look for searches using the following optional parameters:

* address-city
* address-postalcode
* address-state


        )
        optional true
        run_as_group

        test from: :us_core_v700_location_client_support_test
        test from: :us_core_v700_location_client_read_test
        test from: :us_core_v700_location_address_client_search_test
        test from: :us_core_v700_location_address_city_client_search_test
        test from: :us_core_v700_location_address_postalcode_client_search_test
        test from: :us_core_v700_location_address_state_client_search_test
        test from: :us_core_v700_location_name_client_search_test
      end
    end
  end
end
