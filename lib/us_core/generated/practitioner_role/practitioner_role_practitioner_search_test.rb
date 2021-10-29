require_relative '../../search_test'

module USCore
  class PractitionerRolePractitionerSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for PractitionerRole search by practitioner'
    description %(
      A server SHALL support searching by practitioner on the PractitionerRole resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :practitioner_role_practitioner_search_test

    def resource_type
      'PractitionerRole'
    end

    def scratch_resources
      scratch[:practitioner_role_resources] = [] if scratch[:practitioner_role_resources].nil?
      scratch[:practitioner_role_resources]
    end

    def search_params
      {
        'practitioner': search_param_value(find_a_value_at(scratch_resources, 'practitioner'))
      }
    end

    run do
      perform_search_test
    end
  end
end
