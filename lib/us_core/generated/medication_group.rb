require_relative 'medication/medication_read_test'
require_relative 'medication/medication_validation_test'
require_relative 'medication/medication_must_support_test'

module USCore
  class MedicationGroup < Inferno::TestGroup
    title 'Medication Tests'
    # description ''

    id :medication

    test from: :medication_read_test
    test from: :medication_validation_test
    test from: :medication_must_support_test
  end
end
