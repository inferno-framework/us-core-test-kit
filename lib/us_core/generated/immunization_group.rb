require_relative 'immunization/immunization_patient_search_test'
require_relative 'immunization/immunization_patient_date_search_test'
require_relative 'immunization/immunization_patient_status_search_test'
require_relative 'immunization/immunization_read_test'
require_relative 'immunization/immunization_provenance_revinclude_search_test'
require_relative 'immunization/immunization_validation_test'
require_relative 'immunization/immunization_must_support_test'
require_relative 'immunization/immunization_reference_resolution_test'

module USCore
  class ImmunizationGroup < Inferno::TestGroup
    title 'Immunization Tests'
    # description ''

    id :immunization

    test from: :immunization_patient_search_test
    test from: :immunization_patient_date_search_test
    test from: :immunization_patient_status_search_test
    test from: :immunization_read_test
    test from: :immunization_provenance_revinclude_search_test
    test from: :immunization_validation_test
    test from: :immunization_must_support_test
    test from: :immunization_reference_resolution_test
  end
end
