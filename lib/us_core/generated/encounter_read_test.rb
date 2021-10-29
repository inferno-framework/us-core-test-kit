require_relative '../read_test'

module USCore
  class EncounterReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Encounter resource from Encounter read interaction'
    description 'A server SHALL support the Encounter read interaction.'

    id :encounter_read_test

    def resource_type
      'Encounter'
    end

    run do
      perform_read_test(scratch[:encounter_resources])
    end
  end
end
