require_relative 'patient/patient_id_search_test'
require_relative 'patient/patient_identifier_search_test'
require_relative 'patient/patient_name_search_test'
require_relative 'patient/patient_birthdate_family_search_test'
require_relative 'patient/patient_family_gender_search_test'
require_relative 'patient/patient_birthdate_name_search_test'
require_relative 'patient/patient_gender_name_search_test'
require_relative 'patient/patient_read_test'
require_relative 'patient/patient_provenance_revinclude_search_test'
require_relative 'patient/patient_validation_test'
require_relative 'patient/patient_must_support_test'
require_relative 'patient/patient_reference_resolution_test'

module USCore
  class PatientGroup < Inferno::TestGroup
    title 'Patient Tests'
    # description ''

    id :patient

    test from: :patient__id_search_test
    test from: :patient_identifier_search_test
    test from: :patient_name_search_test
    test from: :patient_birthdate_family_search_test
    test from: :patient_family_gender_search_test
    test from: :patient_birthdate_name_search_test
    test from: :patient_gender_name_search_test
    test from: :patient_read_test
    test from: :patient_provenance_revinclude_search_test
    test from: :patient_validation_test
    test from: :patient_must_support_test
    test from: :patient_reference_resolution_test
  end
end
