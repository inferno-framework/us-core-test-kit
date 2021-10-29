require_relative '../read_test'

module USCore
  class ImmunizationReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Immunization resource from Immunization read interaction'
    description 'A server SHALL support the Immunization read interaction.'

    id :immunization_read_test

    def resource_type
      'Immunization'
    end

    run do
      perform_read_test(scratch[:immunization_resources])
    end
  end
end
