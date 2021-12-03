require_relative 'medication_request/medication_request_patient_intent_search_test'
require_relative 'medication_request/medication_request_patient_intent_encounter_search_test'
require_relative 'medication_request/medication_request_patient_intent_authoredon_search_test'
require_relative 'medication_request/medication_request_patient_intent_status_search_test'
require_relative 'medication_request/medication_request_read_test'
require_relative 'medication_request/medication_request_provenance_revinclude_search_test'
require_relative 'medication_request/medication_request_validation_test'
require_relative 'medication_request/medication_validation_test'
require_relative 'medication_request/medication_request_must_support_test'
require_relative 'medication_request/medication_request_reference_resolution_test'

module USCore
  class MedicationRequestGroup < Inferno::TestGroup
    title 'MedicationRequest Tests'
    # description ''

    id :medication_request

    test from: :medication_request_patient_intent_search_test
    test from: :medication_request_patient_intent_encounter_search_test
    test from: :medication_request_patient_intent_authoredon_search_test
    test from: :medication_request_patient_intent_status_search_test
    test from: :medication_request_read_test
    test from: :medication_request_provenance_revinclude_search_test
    test from: :medication_request_validation_test
    test from: :medication_validation_test
    test from: :medication_request_must_support_test
    test from: :medication_request_reference_resolution_test
  end
end
