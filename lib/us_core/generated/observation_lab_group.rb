require_relative 'observation_lab_read_test'

module USCore
  class ObservationLabGroup < Inferno::TestGroup
    title 'ObservationLab Tests'
    # description ''

    id :observation_lab

    test from: :observation_lab_read_test
  end
end
