require_relative 'procedure/procedure_read_test'

module USCore
  class ProcedureGroup < Inferno::TestGroup
    title 'Procedure Tests'
    # description ''

    id :procedure

    test from: :procedure_read_test
  end
end
