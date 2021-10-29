require_relative 'smokingstatus/smokingstatus_read_test'

module USCore
  class SmokingstatusGroup < Inferno::TestGroup
    title 'Smokingstatus Tests'
    # description ''

    id :smokingstatus

    test from: :smokingstatus_read_test
  end
end
