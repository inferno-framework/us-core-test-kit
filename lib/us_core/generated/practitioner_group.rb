require_relative 'practitioner_read_test'

module USCore
  class PractitionerGroup < Inferno::TestGroup
    title 'Practitioner Tests'
    # description ''

    id :practitioner

    test from: :practitioner_read_test
  end
end
