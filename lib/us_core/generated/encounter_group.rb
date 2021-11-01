require_relative 'encounter/encounter_read_test'
require_relative 'encounter/encounter_patient_search_test'
require_relative 'encounter/encounter_id_search_test'
require_relative 'encounter/encounter_class_search_test'
require_relative 'encounter/encounter_date_search_test'
require_relative 'encounter/encounter_identifier_search_test'
require_relative 'encounter/encounter_status_search_test'
require_relative 'encounter/encounter_type_search_test'
require_relative 'encounter/encounter_class_patient_search_test'
require_relative 'encounter/encounter_patient_status_search_test'
require_relative 'encounter/encounter_patient_type_search_test'
require_relative 'encounter/encounter_date_patient_search_test'

module USCore
  class EncounterGroup < Inferno::TestGroup
    title 'Encounter Tests'
    # description ''

    id :encounter

    test from: :encounter_read_test
    test from: :encounter_patient_search_test
    test from: :encounter__id_search_test
    test from: :encounter_class_search_test
    test from: :encounter_date_search_test
    test from: :encounter_identifier_search_test
    test from: :encounter_status_search_test
    test from: :encounter_type_search_test
    test from: :encounter_class_patient_search_test
    test from: :encounter_patient_status_search_test
    test from: :encounter_patient_type_search_test
    test from: :encounter_date_patient_search_test
  end
end
