require_relative 'observation_lab/observation_lab_patient_category_search_test'
require_relative 'observation_lab/observation_lab_status_search_test'
require_relative 'observation_lab/observation_lab_category_search_test'
require_relative 'observation_lab/observation_lab_code_search_test'
require_relative 'observation_lab/observation_lab_date_search_test'
require_relative 'observation_lab/observation_lab_patient_search_test'
require_relative 'observation_lab/observation_lab_patient_category_date_search_test'
require_relative 'observation_lab/observation_lab_patient_category_status_search_test'
require_relative 'observation_lab/observation_lab_patient_code_date_search_test'
require_relative 'observation_lab/observation_lab_patient_code_search_test'
require_relative 'observation_lab/observation_lab_read_test'
require_relative 'observation_lab/observation_lab_validation_test'

module USCore
  class ObservationLabGroup < Inferno::TestGroup
    title 'ObservationLab Tests'
    # description ''

    id :observation_lab

    test from: :observation_lab_patient_category_search_test
    test from: :observation_lab_status_search_test
    test from: :observation_lab_category_search_test
    test from: :observation_lab_code_search_test
    test from: :observation_lab_date_search_test
    test from: :observation_lab_patient_search_test
    test from: :observation_lab_patient_category_date_search_test
    test from: :observation_lab_patient_category_status_search_test
    test from: :observation_lab_patient_code_date_search_test
    test from: :observation_lab_patient_code_search_test
    test from: :observation_lab_read_test
    test from: :observation_lab_validation_test
  end
end
