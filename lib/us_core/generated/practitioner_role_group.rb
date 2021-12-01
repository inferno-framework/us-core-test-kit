require_relative 'practitioner_role/practitioner_role_read_test'
require_relative 'practitioner_role/practitioner_role_specialty_search_test'
require_relative 'practitioner_role/practitioner_role_practitioner_search_test'
require_relative 'practitioner_role/practitioner_role_validation_test'

module USCore
  class PractitionerRoleGroup < Inferno::TestGroup
    title 'PractitionerRole Tests'
    # description ''

    id :practitioner_role

    test from: :practitioner_role_read_test
    test from: :practitioner_role_specialty_search_test
    test from: :practitioner_role_practitioner_search_test
    test from: :practitioner_role_validation_test
  end
end
