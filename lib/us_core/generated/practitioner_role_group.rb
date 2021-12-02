require_relative 'practitioner_role/practitioner_role_read_test'
require_relative 'practitioner_role/practitioner_role_specialty_search_test'
require_relative 'practitioner_role/practitioner_role_practitioner_search_test'
require_relative 'practitioner_role/practitioner_role_validation_test'
require_relative 'practitioner_role/practitioner_role_must_support_test'
require_relative 'practitioner_role/practitioner_role_reference_resolution_test'

module USCore
  class PractitionerRoleGroup < Inferno::TestGroup
    title 'PractitionerRole Tests'
    # description ''

    id :practitioner_role

    test from: :practitioner_role_read_test
    test from: :practitioner_role_specialty_search_test
    test from: :practitioner_role_practitioner_search_test
    test from: :practitioner_role_validation_test
    test from: :practitioner_role_must_support_test
    test from: :practitioner_role_reference_resolution_test
  end
end
