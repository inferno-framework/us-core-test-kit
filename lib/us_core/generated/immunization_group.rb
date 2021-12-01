require_relative 'immunization/immunization_patient_search_test'
require_relative 'immunization/immunization_status_search_test'
require_relative 'immunization/immunization_date_search_test'
require_relative 'immunization/immunization_patient_date_search_test'
require_relative 'immunization/immunization_patient_status_search_test'
require_relative 'immunization/immunization_read_test'
require_relative 'immunization/immunization_validation_test'

module USCore
  class ImmunizationGroup < Inferno::TestGroup
    title 'Immunization Tests'
    # description ''

    id :immunization

    test from: :immunization_patient_search_test
    test from: :immunization_status_search_test
    test from: :immunization_date_search_test
    test from: :immunization_patient_date_search_test
    test from: :immunization_patient_status_search_test
    test from: :immunization_read_test
    test from: :immunization_validation_test
  end
end
