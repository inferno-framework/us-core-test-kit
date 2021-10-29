require_relative '../read_test'

module USCore
  class MedicationReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Medication resource from Medication read interaction'
    description 'A server SHALL support the Medication read interaction.'

    id :medication_read_test

    def resource_type
      'Medication'
    end

    run do
      perform_read_test(scratch[:medication_resources])
    end
  end
end
