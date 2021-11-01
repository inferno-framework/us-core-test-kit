require_relative 'smokingstatus/smokingstatus_patient_code_search_test'
require_relative 'smokingstatus/smokingstatus_status_search_test'
require_relative 'smokingstatus/smokingstatus_category_search_test'
require_relative 'smokingstatus/smokingstatus_code_search_test'
require_relative 'smokingstatus/smokingstatus_date_search_test'
require_relative 'smokingstatus/smokingstatus_patient_search_test'
require_relative 'smokingstatus/smokingstatus_patient_category_date_search_test'
require_relative 'smokingstatus/smokingstatus_patient_category_status_search_test'
require_relative 'smokingstatus/smokingstatus_patient_code_date_search_test'
require_relative 'smokingstatus/smokingstatus_patient_category_search_test'
require_relative 'smokingstatus/smokingstatus_read_test'

module USCore
  class SmokingstatusGroup < Inferno::TestGroup
    title 'Smokingstatus Tests'
    # description ''

    id :smokingstatus

    test from: :smokingstatus_patient_code_search_test
    test from: :smokingstatus_status_search_test
    test from: :smokingstatus_category_search_test
    test from: :smokingstatus_code_search_test
    test from: :smokingstatus_date_search_test
    test from: :smokingstatus_patient_search_test
    test from: :smokingstatus_patient_category_date_search_test
    test from: :smokingstatus_patient_category_status_search_test
    test from: :smokingstatus_patient_code_date_search_test
    test from: :smokingstatus_patient_category_search_test
    test from: :smokingstatus_read_test
  end
end