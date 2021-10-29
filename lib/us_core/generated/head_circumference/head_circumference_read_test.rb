require_relative '../../read_test'

module USCore
  class HeadCircumferenceReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Observation resource from Observation read interaction'
    description 'A server SHALL support the Observation read interaction.'

    id :head_circumference_read_test

    def resource_type
      'Observation'
    end

    run do
      perform_read_test(scratch[:head_circumference_resources])
    end
  end
end
