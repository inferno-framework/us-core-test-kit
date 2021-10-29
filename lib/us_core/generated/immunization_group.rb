require_relative 'immunization_read_test'

module USCore
  class ImmunizationGroup < Inferno::TestGroup
    title 'Immunization Tests'
    # description ''

    id :immunization

    test from: :immunization_read_test
  end
end
