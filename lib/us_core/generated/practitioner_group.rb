require_relative 'practitioner/practitioner_read_test'
require_relative 'practitioner/practitioner_name_search_test'
require_relative 'practitioner/practitioner_identifier_search_test'
require_relative 'practitioner/practitioner_validation_test'
require_relative 'practitioner/practitioner_must_support_test'
require_relative 'practitioner/practitioner_reference_resolution_test'

module USCore
  class PractitionerGroup < Inferno::TestGroup
    title 'Practitioner Tests'
    # description ''

    id :practitioner

    test from: :practitioner_read_test
    test from: :practitioner_name_search_test
    test from: :practitioner_identifier_search_test
    test from: :practitioner_validation_test
    test from: :practitioner_must_support_test
    test from: :practitioner_reference_resolution_test
  end
end
