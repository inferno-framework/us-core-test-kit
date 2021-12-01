require_relative 'procedure/procedure_patient_search_test'
require_relative 'procedure/procedure_status_search_test'
require_relative 'procedure/procedure_date_search_test'
require_relative 'procedure/procedure_code_search_test'
require_relative 'procedure/procedure_patient_date_search_test'
require_relative 'procedure/procedure_patient_status_search_test'
require_relative 'procedure/procedure_patient_code_date_search_test'
require_relative 'procedure/procedure_read_test'
require_relative 'procedure/procedure_validation_test'

module USCore
  class ProcedureGroup < Inferno::TestGroup
    title 'Procedure Tests'
    # description ''

    id :procedure

    test from: :procedure_patient_search_test
    test from: :procedure_status_search_test
    test from: :procedure_date_search_test
    test from: :procedure_code_search_test
    test from: :procedure_patient_date_search_test
    test from: :procedure_patient_status_search_test
    test from: :procedure_patient_code_date_search_test
    test from: :procedure_read_test
    test from: :procedure_validation_test
  end
end
