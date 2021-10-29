require_relative '../../read_test'

module USCore
  class PediatricWeightForHeightReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Observation resource from Observation read interaction'
    description 'A server SHALL support the Observation read interaction.'

    id :pediatric_weight_for_height_read_test

    def resource_type
      'Observation'
    end

    run do
      perform_read_test(scratch[:pediatric_weight_for_height_resources])
    end
  end
end
