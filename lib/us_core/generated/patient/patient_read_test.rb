require_relative '../../read_test'

module USCore
  class PatientReadTest < Inferno::Test
    include USCore::ReadTest

    title 'Server returns correct Patient resource from Patient read interaction'
    description 'A server SHALL support the Patient read interaction.'

    id :patient_read_test

    def resource_type
      'Patient'
    end

    def scratch_resources
      scratch[:patient_resources] ||= []
    end

    run do
      perform_read_test(scratch_resources)
    end
  end
end
