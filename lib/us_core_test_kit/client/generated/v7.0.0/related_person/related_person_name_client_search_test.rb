# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class RelatedPersonNameClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v700_related_person_name_client_search_test
        title 'SHOULD support name search of RelatedPerson'
        description %(
          The client demonstrates SHOULD support for searching name on RelatedPerson.
        )
        optional true

        def required_params
          ["name"]
        end

        def skip_message
          "Inferno did not receive any search requests for the `RelatedPerson` resource type."
        end

        def failure_message
          "Inferno did not receive the expected search made for the `RelatedPerson` resource type with required search parameters: `#{required_params.join(' + ')}`."
        end

        run do
          requests = load_tagged_requests(SEARCH_RELATED_PERSON_TAG)
          skip_if requests.blank?, skip_message

          requests_with_params = filter_requests_by_search_parameters(requests, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
