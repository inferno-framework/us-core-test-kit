require_relative 'encounter/encounter_read_test'
require_relative 'encounter/encounter_patient_search_test'
require_relative 'encounter/encounter_id_search_test'
require_relative 'encounter/encounter_identifier_search_test'
require_relative 'encounter/encounter_class_patient_search_test'
require_relative 'encounter/encounter_patient_status_search_test'
require_relative 'encounter/encounter_patient_type_search_test'
require_relative 'encounter/encounter_date_patient_search_test'
require_relative 'encounter/encounter_provenance_revinclude_search_test'
require_relative 'encounter/encounter_validation_test'
require_relative 'encounter/encounter_must_support_test'
require_relative 'encounter/encounter_reference_resolution_test'

module USCore
  class EncounterGroup < Inferno::TestGroup
    title 'Encounter Tests'
    # description ''

    id :encounter

    test from: :encounter_read_test
    test from: :encounter_patient_search_test
    test from: :encounter__id_search_test
    test from: :encounter_identifier_search_test
    test from: :encounter_class_patient_search_test
    test from: :encounter_patient_status_search_test
    test from: :encounter_patient_type_search_test
    test from: :encounter_date_patient_search_test
    test from: :encounter_provenance_revinclude_search_test
    test from: :encounter_validation_test
    test from: :encounter_must_support_test
    test from: :encounter_reference_resolution_test
  end
end
