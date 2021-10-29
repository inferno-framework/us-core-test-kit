require_relative '../../read_test'

module USCore
  class PractitionerReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Practitioner resource from Practitioner read interaction'
    description 'A server SHALL support the Practitioner read interaction.'

    id :practitioner_read_test

    def resource_type
      'Practitioner'
    end

    run do
      perform_read_test(scratch[:practitioner_resources])
    end
  end
end
