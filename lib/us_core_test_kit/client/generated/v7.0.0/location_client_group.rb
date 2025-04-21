# frozen_string_literal: true

require_relative 'location/location_client_read_test'
require_relative 'location/location_address_client_search_test'
require_relative 'location/location_name_client_search_test'

module USCoreTestKit
  module Client
    module USCoreClientV700
      class LocationClientGroup < Inferno::TestGroup
        id :us_core_client_v700_location

        title 'Location'

        description %(
          
# Background

This test group verifies that the client under test is
able to perform the required Location queries.

# Testing Methodology

## Reading
This sequence will check that the client performed a search with the following ID:

* `us-core-client-tests-location`

## Searching
This sequence will check that the client performed searches with the following parameters:

* address
* name

        )

        run_as_group

        test from: :us_core_v700_location_client_read_test
        test from: :us_core_v700_location_address_client_search_test
        test from: :us_core_v700_location_name_client_search_test
      end
    end
  end
end
