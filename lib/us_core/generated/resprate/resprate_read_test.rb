require_relative '../../read_test'

module USCore
  class ResprateReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Observation resource from Observation read interaction'
    description 'A server SHALL support the Observation read interaction.'

    id :us_core_311_resprate_read_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:resprate_resources] ||= {}
    end

    run do
      perform_read_test(all_scratch_resources)
    end
  end
end
