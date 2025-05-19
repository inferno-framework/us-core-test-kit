# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV501
      class RelatedPersonIdClientSearchTest < Inferno::Test
        include TestHelper

        id :us_core_v501_related_person_id_client_search_test

        title 'SHALL support _id search of RelatedPerson'

        description %(
          The client demonstrates SHALL support for searching _id on RelatedPerson.
        )

        def required_params
          ["_id"]
        end

        def failure_message
          "Did not receive a request for `RelatedPerson` with required search parameters: `#{required_params.join(' + ')}`"
        end

        run do
          requests = load_tagged_requests(SEARCH_RELATED_PERSON_TAG)
          requests = load_tagged_requests(SEARCH_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'RelatedPerson')
          requests_with_params = filter_requests_by_search_parameters(requests_of_type, required_params)
          assert requests_with_params.any?, failure_message
        end
      end
    end
  end
end
