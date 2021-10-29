require_relative 'medication/medication_read_test'

module USCore
  class MedicationGroup < Inferno::TestGroup
    title 'Medication Tests'
    # description ''

    id :medication

    test from: :medication_read_test
  end
end
