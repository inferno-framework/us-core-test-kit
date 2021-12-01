require_relative 'practitioner/practitioner_read_test'
require_relative 'practitioner/practitioner_name_search_test'
require_relative 'practitioner/practitioner_identifier_search_test'
require_relative 'practitioner/practitioner_validation_test'

module USCore
  class PractitionerGroup < Inferno::TestGroup
    title 'Practitioner Tests'
    # description ''

    id :practitioner

    test from: :practitioner_read_test
    test from: :practitioner_name_search_test
    test from: :practitioner_identifier_search_test
    test from: :practitioner_validation_test
  end
end
