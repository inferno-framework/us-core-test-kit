require_relative '../../read_test'

module USCore
  class SmokingstatusReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Observation resource from Observation read interaction'
    description 'A server SHALL support the Observation read interaction.'

    id :smokingstatus_read_test

    def resource_type
      'Observation'
    end

    run do
      perform_read_test(scratch[:smokingstatus_resources])
    end
  end
end
