require_relative 'medication/medication_read_test'
require_relative 'medication/medication_validation_test'
require_relative 'medication/medication_must_support_test'
require_relative 'medication/medication_reference_resolution_test'

module USCore
  class MedicationGroup < Inferno::TestGroup
    title 'Medication Tests'
    # description ''

    id :medication

    test from: :medication_read_test
    test from: :medication_validation_test
    test from: :medication_must_support_test
    test from: :medication_reference_resolution_test
  end
end
