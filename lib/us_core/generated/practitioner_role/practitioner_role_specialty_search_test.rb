require_relative '../../search_test'

module USCore
  class PractitionerRoleSpecialtySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for PractitionerRole search by specialty'
    description %(
      A server SHALL support searching by specialty on the PractitionerRole resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :practitioner_role_specialty_search_test

    def resource_type
      'PractitionerRole'
    end

    def scratch_resources
      scratch[:practitioner_role_resources] = [] if scratch[:practitioner_role_resources].nil?
      scratch[:practitioner_role_resources]
    end

    def search_params
      {
        'specialty': search_param_value(find_a_value_at(scratch_resources, 'specialty'))
      }
    end

    run do
      perform_search_test
    end
  end
end
