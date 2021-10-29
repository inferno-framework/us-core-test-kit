require_relative 'medication_request_read_test'

module USCore
  class MedicationRequestGroup < Inferno::TestGroup
    title 'MedicationRequest Tests'
    # description ''

    id :medication_request

    test from: :medication_request_read_test
  end
end
