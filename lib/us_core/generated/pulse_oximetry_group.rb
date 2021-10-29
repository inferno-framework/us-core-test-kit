require_relative 'pulse_oximetry_read_test'

module USCore
  class PulseOximetryGroup < Inferno::TestGroup
    title 'PulseOximetry Tests'
    # description ''

    id :pulse_oximetry

    test from: :pulse_oximetry_read_test
  end
end
