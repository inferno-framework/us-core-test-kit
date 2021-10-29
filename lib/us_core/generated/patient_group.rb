require_relative 'patient/patient_read_test'

module USCore
  class PatientGroup < Inferno::TestGroup
    title 'Patient Tests'
    # description ''

    id :patient

    test from: :patient_read_test
  end
end
