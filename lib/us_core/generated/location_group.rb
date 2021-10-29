require_relative 'location_read_test'

module USCore
  class LocationGroup < Inferno::TestGroup
    title 'Location Tests'
    # description ''

    id :location

    test from: :location_read_test
  end
end
