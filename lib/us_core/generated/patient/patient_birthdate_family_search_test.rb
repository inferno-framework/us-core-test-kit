require_relative '../../search_test'

module USCore
  class PatientBirthdateFamilySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Patient search by birthdate + family'
    description %(
      A server SHOULD support searching by birthdate + family on the Patient resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :patient_birthdate_family_search_test

    def resource_type
      'Patient'
    end

    def scratch_resources
      scratch[:patient_resources] ||= []
    end

    def search_params
      {
        'birthdate': search_param_value('birthDate'),
        'family': search_param_value('name.family')
      }
    end

    run do
      perform_search_test
    end
  end
end
