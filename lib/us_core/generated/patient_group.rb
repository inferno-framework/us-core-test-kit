require_relative 'patient/patient_id_search_test'
require_relative 'patient/patient_birthdate_search_test'
require_relative 'patient/patient_family_search_test'
require_relative 'patient/patient_gender_search_test'
require_relative 'patient/patient_given_search_test'
require_relative 'patient/patient_identifier_search_test'
require_relative 'patient/patient_name_search_test'
require_relative 'patient/patient_birthdate_family_search_test'
require_relative 'patient/patient_family_gender_search_test'
require_relative 'patient/patient_birthdate_name_search_test'
require_relative 'patient/patient_gender_name_search_test'
require_relative 'patient/patient_read_test'

module USCore
  class PatientGroup < Inferno::TestGroup
    title 'Patient Tests'
    # description ''

    id :patient

    test from: :patient__id_search_test
    test from: :patient_birthdate_search_test
    test from: :patient_family_search_test
    test from: :patient_gender_search_test
    test from: :patient_given_search_test
    test from: :patient_identifier_search_test
    test from: :patient_name_search_test
    test from: :patient_birthdate_family_search_test
    test from: :patient_family_gender_search_test
    test from: :patient_birthdate_name_search_test
    test from: :patient_gender_name_search_test
    test from: :patient_read_test
  end
end
