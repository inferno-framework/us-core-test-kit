require_relative '../../search_test'

module USCore
  class PractitionerIdentifierSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Practitioner search by identifier'
    description %(
      A server SHALL support searching by identifier on the Practitioner resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :practitioner_identifier_search_test

    def resource_type
      'Practitioner'
    end

    def scratch_resources
      scratch[:practitioner_resources] ||= []
    end

    def search_params
      {
        'identifier': search_param_value('identifier')
      }
    end

    run do
      perform_search_test
    end
  end
end