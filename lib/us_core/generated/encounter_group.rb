require_relative 'encounter/encounter_read_test'

module USCore
  class EncounterGroup < Inferno::TestGroup
    title 'Encounter Tests'
    # description ''

    id :encounter

    test from: :encounter_read_test
  end
end
