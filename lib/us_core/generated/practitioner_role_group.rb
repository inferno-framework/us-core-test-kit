require_relative 'practitioner_role_read_test'

module USCore
  class PractitionerRoleGroup < Inferno::TestGroup
    title 'PractitionerRole Tests'
    # description ''

    id :practitioner_role

    test from: :practitioner_role_read_test
  end
end
