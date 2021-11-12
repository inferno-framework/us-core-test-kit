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

    def scratch_resources
      scratch[:practitioner_resources] ||= {}
    end

    run do
      perform_read_test(scratch.dig(:references, 'Practitioner'))
    end
  end
end
