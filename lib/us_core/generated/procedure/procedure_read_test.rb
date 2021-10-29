require_relative '../read_test'

module USCore
  class ProcedureReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Procedure resource from Procedure read interaction'
    description 'A server SHALL support the Procedure read interaction.'

    id :procedure_read_test

    def resource_type
      'Procedure'
    end

    run do
      perform_read_test(scratch[:procedure_resources])
    end
  end
end
