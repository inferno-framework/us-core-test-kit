# frozen_string_literal: true

module USCoreTestKit
  module Client
    module USCoreClientV700
      class RelatedPersonClientReadTest < Inferno::Test
        include TestHelper

        id :us_core_v700_related_person_client_read_test

        title 'SHALL support read of RelatedPerson'

        description %(
          The client demonstrates SHALL support for reading RelatedPerson.
        )

        def failure_message
          "Did not receive a request for `RelatedPerson` with id: `us-core-client-tests-related-person`."
        end

        run do
          requests = load_tagged_requests(READ_RELATED_PERSON_TAG)
          requests = load_tagged_requests(READ_REQUEST_TAG) if requests.empty?
          requests_of_type = filter_requests_by_resource_type(requests, 'RelatedPerson')
          requests_for_id = filter_requests_by_resource_id(requests_of_type, 'us-core-client-tests-related-person')
          assert requests_for_id.any?, failure_message
        end
      end
    end
  end
end
