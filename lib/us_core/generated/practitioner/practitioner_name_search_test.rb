require_relative '../../search_test'

module USCore
  class PractitionerNameSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Practitioner search by name'
    description %(
      A server SHALL support searching by name on the Practitioner resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :practitioner_name_search_test

    def resource_type
      'Practitioner'
    end

    def scratch_resources
      scratch[:practitioner_resources] = [] if scratch[:practitioner_resources].nil?
      scratch[:practitioner_resources]
    end

    def search_params
      {
        'name': search_param_value(find_a_value_at(scratch_resources, 'name'))
      }
    end

    run do
      perform_search_test
    end
  end
end
