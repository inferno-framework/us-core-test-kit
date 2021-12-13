require_relative '../../read_test'

module USCore
  class ImmunizationReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Immunization resource from Immunization read interaction'
    description 'A server SHALL support the Immunization read interaction.'

    id :us_core_311_immunization_read_test

    def resource_type
      'Immunization'
    end

    def scratch_resources
      scratch[:immunization_resources] ||= {}
    end

    run do
      perform_read_test(all_scratch_resources)
    end
  end
end
