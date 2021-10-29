require_relative '../../search_test'

module USCore
  class PatientIdSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Patient search by _id'
    description %(
      A server SHALL support searching by _id on the Patient resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :patient__id_search_test

    def resource_type
      'Patient'
    end

    def scratch_resources
      scratch[:patient_resources] = [] if scratch[:patient_resources].nil?
      scratch[:patient_resources]
    end

    def search_params
      {
        '_id': search_param_value(find_a_value_at(scratch_resources, 'id'))
      }
    end

    run do
      perform_search_test
    end
  end
end
