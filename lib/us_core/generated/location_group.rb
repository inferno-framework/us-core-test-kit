require_relative 'location/location_read_test'
require_relative 'location/location_name_search_test'
require_relative 'location/location_address_search_test'
require_relative 'location/location_address_city_search_test'
require_relative 'location/location_address_state_search_test'
require_relative 'location/location_address_postalcode_search_test'

module USCore
  class LocationGroup < Inferno::TestGroup
    title 'Location Tests'
    # description ''

    id :location

    test from: :location_read_test
    test from: :location_name_search_test
    test from: :location_address_search_test
    test from: :location_address_city_search_test
    test from: :location_address_state_search_test
    test from: :location_address_postalcode_search_test
  end
end
