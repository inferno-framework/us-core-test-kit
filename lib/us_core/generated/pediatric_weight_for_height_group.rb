require_relative 'pediatric_weight_for_height/pediatric_weight_for_height_read_test'

module USCore
  class PediatricWeightForHeightGroup < Inferno::TestGroup
    title 'PediatricWeightForHeight Tests'
    # description ''

    id :pediatric_weight_for_height

    test from: :pediatric_weight_for_height_read_test
  end
end
