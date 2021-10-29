require_relative '../read_test'

module USCore
  class PractitionerRoleReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct PractitionerRole resource from PractitionerRole read interaction'
    description 'A server SHALL support the PractitionerRole read interaction.'

    id :practitioner_role_read_test

    def resource_type
      'PractitionerRole'
    end

    run do
      perform_read_test(scratch[:practitioner_role_resources])
    end
  end
end
