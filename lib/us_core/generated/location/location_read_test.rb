require_relative '../../read_test'

module USCore
  class LocationReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Location resource from Location read interaction'
    description 'A server SHALL support the Location read interaction.'

    id :location_read_test

    def resource_type
      'Location'
    end

    run do
      perform_read_test(scratch[:location_resources])
    end
  end
end
