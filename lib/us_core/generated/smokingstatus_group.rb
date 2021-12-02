require_relative 'smokingstatus/smokingstatus_patient_code_search_test'
require_relative 'smokingstatus/smokingstatus_patient_category_date_search_test'
require_relative 'smokingstatus/smokingstatus_patient_category_status_search_test'
require_relative 'smokingstatus/smokingstatus_patient_code_date_search_test'
require_relative 'smokingstatus/smokingstatus_patient_category_search_test'
require_relative 'smokingstatus/smokingstatus_read_test'
require_relative 'smokingstatus/smokingstatus_provenance_revinclude_search_test'
require_relative 'smokingstatus/smokingstatus_validation_test'
require_relative 'smokingstatus/smokingstatus_must_support_test'
require_relative 'smokingstatus/smokingstatus_reference_resolution_test'

module USCore
  class SmokingstatusGroup < Inferno::TestGroup
    title 'Smokingstatus Tests'
    # description ''

    id :smokingstatus

    test from: :smokingstatus_patient_code_search_test
    test from: :smokingstatus_patient_category_date_search_test
    test from: :smokingstatus_patient_category_status_search_test
    test from: :smokingstatus_patient_code_date_search_test
    test from: :smokingstatus_patient_category_search_test
    test from: :smokingstatus_read_test
    test from: :smokingstatus_provenance_revinclude_search_test
    test from: :smokingstatus_validation_test
    test from: :smokingstatus_must_support_test
    test from: :smokingstatus_reference_resolution_test
  end
end
