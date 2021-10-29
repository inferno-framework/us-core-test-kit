require_relative '../../search_test'

module USCore
  class PatientGenderNameSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Patient search by gender + name'
    description %(
      A server SHALL support searching by gender + name on the Patient resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :patient_gender_name_search_test

    def resource_type
      'Patient'
    end

    def scratch_resources
      scratch[:patient_resources] = [] if scratch[:patient_resources].nil?
      scratch[:patient_resources]
    end

    def search_params
      {
        'gender': search_param_value(find_a_value_at(scratch_resources, 'gender')),
        'name': search_param_value(find_a_value_at(scratch_resources, 'name'))
      }
    end

    run do
      perform_search_test
    end
  end
end
