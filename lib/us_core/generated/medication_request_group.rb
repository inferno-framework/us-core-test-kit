require_relative 'medication_request/medication_request_patient_intent_search_test'
require_relative 'medication_request/medication_request_status_search_test'
require_relative 'medication_request/medication_request_intent_search_test'
require_relative 'medication_request/medication_request_patient_search_test'
require_relative 'medication_request/medication_request_encounter_search_test'
require_relative 'medication_request/medication_request_authoredon_search_test'
require_relative 'medication_request/medication_request_patient_intent_encounter_search_test'
require_relative 'medication_request/medication_request_patient_intent_authoredon_search_test'
require_relative 'medication_request/medication_request_patient_intent_status_search_test'
require_relative 'medication_request/medication_request_read_test'

module USCore
  class MedicationRequestGroup < Inferno::TestGroup
    title 'MedicationRequest Tests'
    # description ''

    id :medication_request

    test from: :medication_request_patient_intent_search_test
    test from: :medication_request_status_search_test
    test from: :medication_request_intent_search_test
    test from: :medication_request_patient_search_test
    test from: :medication_request_encounter_search_test
    test from: :medication_request_authoredon_search_test
    test from: :medication_request_patient_intent_encounter_search_test
    test from: :medication_request_patient_intent_authoredon_search_test
    test from: :medication_request_patient_intent_status_search_test
    test from: :medication_request_read_test
  end
end
